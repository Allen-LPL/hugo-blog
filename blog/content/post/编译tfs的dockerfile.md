---
title: 编译tfs的dockerfile文件
date: 2022-11-05 18:34:08
tags: [Docker TensorFlowServer]
categories: [手艺]
---
最近在做机器学习的服务搭建， 使用的是docker容器内编译， 性能直接提升了30%， 以下是Bazel5.1.1编译
<!-- more -->
<The rest of contents | 余下全文>

> 如果你是在墙内， 那你需要参考《Linux Dockerfile build时请求超时的问题解决》以解决编译时的超时问题。
> 如果你是在墙外， 请注释*RUN git config --global https.proxy https://172.17.0.1:10809*这一行

# 编译镜像
```docker
FROM ubuntu:18.04 as base_build

ARG TF_SERVING_VERSION_GIT_BRANCH=master
ARG TF_SERVING_VERSION_GIT_COMMIT=HEAD

LABEL maintainer=gvasudevan@google.com
LABEL tensorflow_serving_github_branchtag=${TF_SERVING_VERSION_GIT_BRANCH}
LABEL tensorflow_serving_github_commit=${TF_SERVING_VERSION_GIT_COMMIT}

RUN apt-get update && apt-get install -y --no-install-recommends \
        automake \
        build-essential \
        ca-certificates \
        curl \
        git \
        libcurl3-dev \
        libfreetype6-dev \
        libpng-dev \
        libtool \
        libzmq3-dev \
        mlocate \
        openjdk-8-jdk\
        openjdk-8-jre-headless \
        pkg-config \
        python-dev \
        software-properties-common \
        swig \
        unzip \
        wget \
        zip \
        zlib1g-dev \
        python3-distutils \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install python 3.7.
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.7 python3.7-dev python3-pip python3.7-venv && \
    rm -rf /var/lib/apt/lists/* && \
    python3.7 -m pip install pip --upgrade && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 0

# Make python3.7 the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 0

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN pip3 --no-cache-dir install \
    future>=0.17.1 \
    grpcio \
    h5py \
    keras_applications>=1.0.8 \
    keras_preprocessing>=1.1.0 \
    mock \
    numpy \
    portpicker \
    requests \
    --ignore-installed setuptools \
    --ignore-installed six>=1.12.0

# 需要使用git拉取镜像， 这里指定使用宿主机的代理端口
RUN git config --global https.proxy https://172.17.0.1:10809

# Set up Bazel
ENV BAZEL_VERSION 5.1.1
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh --http1.0 && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE --http1.0 && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# Download TF Serving sources (optionally at specific commit).
WORKDIR /tensorflow-serving
RUN curl -sSL --retry 5 https://github.com/tensorflow/serving/tarball/${TF_SERVING_VERSION_GIT_COMMIT} | tar --strip-components=1 -xzf -

FROM base_build as binary_build
# Build, and install TensorFlow Serving
#ARG TF_SERVING_BUILD_OPTIONS="--config=release"
ARG TF_SERVING_BUILD_OPTIONS="--copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.1 --copt=-msse4.2  --local_ram_resources=2048 --local_cpu_resources=2 --worker_max_instances=2"
RUN echo "Building with build options: ${TF_SERVING_BUILD_OPTIONS}"
ARG TF_SERVING_BAZEL_OPTIONS=""
RUN echo "Building with Bazel options: ${TF_SERVING_BAZEL_OPTIONS}"

RUN bazel build --color=yes --curses=yes \
    ${TF_SERVING_BAZEL_OPTIONS} \
    --verbose_failures \
    --output_filter=DONT_MATCH_ANYTHING \
    ${TF_SERVING_BUILD_OPTIONS} \
    tensorflow_serving/model_servers:tensorflow_model_server && \
    cp bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server \
    /usr/local/bin/

# Build and install TensorFlow Serving API
RUN bazel build --color=yes --curses=yes \
    ${TF_SERVING_BAZEL_OPTIONS} \
    --verbose_failures \
    --output_filter=DONT_MATCH_ANYTHING \
    ${TF_SERVING_BUILD_OPTIONS} \
    tensorflow_serving/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow_serving/tools/pip_package/build_pip_package \
    /tmp/pip && \
    pip --no-cache-dir install --upgrade \ 
    /tmp/pip/tensorflow_serving_api-*.whl && \
    rm -rf /tmp/pip

FROM binary_build as clean_build
# Clean up Bazel cache when done.
RUN bazel clean --expunge --color=yes && \
    rm -rf /root/.cache
CMD ["/bin/bash"]
```

# 查看并启动镜像
```shell
docker images |grep hbbtec/tensorflow-serving-devel
```
如果编译成功， 并生成镜像， 那么启动镜像
```shell
# 拉取模型
mkdir -p ~/tf_serving_model/clip_text 
cd ~/tf_serving_model/ 
wget https://brandai-upload.oss-cn-hangzhou.aliyuncs.com/clip_text.tar.gz 
tar xvzf clip_text.tar.gz -C clip_text

# 启动
docker run --name serving-new \
  -dt \
  -p 8500:8500 \
  -p 8501:8501 \
  -v "$HOME/app/tf_serving_model/clip_text:/models/clip_text" \
  -e MODEL_BASE_PATH=/models -e MODEL_NAME=clip_text \
  -t $USER/tensorflow-serving-devel:latest
```
进入容器
```shell
docker exec -it serving-new /bin/bash
```

启动服务

```shell
tensorflow_model_server --port=8500 --rest_api_port=8501 --model_name=clip_text --model_base_path=/models/clip_text "$@"
```