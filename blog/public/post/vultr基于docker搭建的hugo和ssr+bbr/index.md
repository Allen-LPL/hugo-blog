<!-- more -->

# 前言
迁移Blog，最近一直在研究docker，正好使用docker部署hugo, 以及配置了BBR算法的酸酸乳（ssr）。

# 步骤
直接说方法
## 部署vultr 
在vultr上部署服务器， 选择默认安装docker的服务器，或者在服务器上安装docker
## 部署docker的容器
### 部署hugo
两种部署方式
资料来源于 [BLOG养成记(2) HUGO+DOCKER在GITHUB上建立BLOG](https://orianna-zzo.github.io/blog/2018-01/blog%E5%85%BB%E6%88%90%E8%AE%B02-hugo-docker%E5%9C%A8github%E4%B8%8A%E5%BB%BA%E7%AB%8Bblog/)

#### dockerfile
**需要注意HUGO的版本**，目前我使用的是HUGO v0.40.1

```
FROM alpine:latest
MAINTAINER Zi'ou Zheng <zhengziou@gmail.com>

ENV HUGO_VERSION=0.40.1

# Install Hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN apk add --no-cache py-pygments ca-certificates \
    && cd /tmp \
    && tar -xf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz hugo \
    && mv /tmp/hugo /usr/local/bin/hugo \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Decide working directory
WORKDIR /hugo-site

# Mount volume to host
VOLUME /hugo-site
VOLUME /static-site

# Expose default hugo port
EXPOSE 1313

# # By default, serve site
# ENV HUGO_BASE_URL http://localhost:1313
# CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0
# CMD ["/bin/sh"]

COPY start.sh /start.sh
CMD ["/start.sh"]

```

#### 镜像(推荐)

>docker pull liupengliang/hugo-docker

### 部署SSR-BBR-DOCKER
在docker中部署酸酸乳（ssr）+ 谷歌bbr算法， 实现快速部署

>[https://github.com/Ailen1988/ssr-bbr-docker](https://github.com/Ailen1988/ssr-bbr-docker)


***记得给star***

## 生成容器
### hugo
>docker run --name my-hugo -v $(pwd):/hugo-site -v $(pwd)/public:/static-site -p 80:1313 --rm -it liupengliang/hugo-docker:latest

*命令详解*

* --name 容器命名
* -v 本地目录映射到容器的目录
* -p 本地端口映射到容器的端口
* --rm 执行完删除镜像
* -it 执行并进入容器

其中需要强调的是， 我使用的端口映射， 是将容器中的1313端口直接映射到80端口， 因为hugo本身就可以做web server， 辣么就不需要nginx了。

### 开启SSR-BBR-DOCKER服务
在上面的github地址中， 已经讲解了如何使用， 如果看不明白， 可以直接这么使用。
>docker run --privileged -d -p 465:465/tcp -p 465:465/udp --name ssr-bbr-docker letssudormrf/ssr-bbr-docker -p 465 -k password -m aes-128-ctr -O auth_aes128_sha1 -o http_post

*命令详解*

命令分为两部分
1. docker run --privileged -d -p 465:465/tcp -p 465:465/udp --name ssr-bbr-docker letssudormrf/ssr-bbr-docker
2. -p 465 -k password -m aes-256-cfb -O origin -o plain

> 第一部分是docker的基础命令
> 第二部分是镜像内部需要的命令

* -p 端口
* -k 密码
* -m 加密方法
* -O 协议
* -o 混淆

### 客户端
#### windows
>[ShadowsocksR-Windows](https://github.com/HMBSbige/ShadowsocksR-Windows/releases)
#### mac
>[ShadowsocksX-NG-R](https://github.com/qinyuhang/ShadowsocksX-NG-R/releases)



