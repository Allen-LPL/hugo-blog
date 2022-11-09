---
title: docker部署gitlab, gitlab-cli, gitlab-runner的血与泪
date: 2019-07-23 18:11:26
tags: [Docker, Gitlab]
categories: [手艺]
---
    使用docker部署服务到gitlab, 原本以为只是做个代码库, DevOps要使用jenkins或者walle做, 结果😂... 就这么入了gitlab-cli && gitlab-runner的坑, 爬了两天才爬出来, 仅以此篇祭奠自己的血泪.
<!--more-->
# 安装docker
    > 略
# 安装docker-compose
    > 略

# docker-compose 部署gitlab

## dockerfile && docker-compose
可直接引用[laradock](https://github.com/laradock/laradock)的gitlab部分, 自带gitlab-cli.
本来可以仅仅使用gitlab的代码管理部分就可以了, 不过我发现了devops部分, 那就折腾起来.

------
___

# docker-compose 部署gitlab-runner
## docker-compose部分

### RUNNER ###################################################
    runner:
      image: gitlab/gitlab-runner
      restart: always
      container_name: gitlab-runner
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
        - ./gitlab-runner/config:/etc/gitlab-runner
`

> docker-compose up -d runner
![跑起来的状态](https://i.loli.net/2019/07/23/5d371fcf7c27f51190.png)

## gitlab-runnerの注册
按照[官方文档](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html)的指示, 有三种
 * shell执行
 * docker in docker执行
 * docker套接字执行

我们来一一分解
### shell执行
#### 服务器配置注册信息

     docker exec -it gitlab-runner gitlab-runner register -n \
       --url https://gitlab.com/ \
       --registration-token REGISTRATION_TOKEN \
       --executor shell \
       --tag-list "tag" \
       --description "My Runner"

#### 搭配的命令

     sudo usermod -aG docker gitlab-runner
     sudo -u gitlab-runner -H docker info

#### 搭配的.gitlab-ci.yml配置(需要放到项目根目录)

     before_script:
       - docker info

     build_image:
       script:
         - docker build -t my-docker-image .
         - docker run my-docker-image /script/to/run/tests

#### ~~失败~~
![依旧提示没有权限](https://i.loli.net/2019/07/23/5d371fcfd75b472667.png)

### 使用docker-in-docker执行器
#### 服务器配置注册信息

     sudo gitlab-runner register -n \
       --url https://gitlab.com/ \
       --registration-token REGISTRATION_TOKEN \
       --executor docker \
       --description "My Docker Runner" \
       --docker-image "docker:stable" \
       --tag-list "tag" \
       --docker-privileged

#### 搭配的.gitlab-ci.yml配置(需要放到项目根目录)

     image: docker:stable

     variables:
       # When using dind service we need to instruct docker, to talk with the
       # daemon started inside of the service. The daemon is available with
       # a network connection instead of the default /var/run/docker.sock socket.
       #
       # The 'docker' hostname is the alias of the service container as described at
       # https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#accessing-the-services
       #
       # Note that if you're using the Kubernetes executor, the variable should be set to
       # tcp://localhost:2375/ because of how the Kubernetes executor connects services
       # to the job container
       # DOCKER_HOST: tcp://localhost:2375/
       #
       # For non-Kubernetes executors, we use tcp://docker:2375/
       DOCKER_HOST: tcp://docker:2375/
       # When using dind, it's wise to use the overlayfs driver for
       # improved performance.
       DOCKER_DRIVER: overlay2

     services:
       - docker:dind

     before_script:
       - docker info

     build:
       stage: build
       script:
         - docker build -t my-docker-image .
         - docker run my-docker-image /script/to/run/tests

#### ~~失败~~
![docker链接不上](https://i.loli.net/2019/07/23/5d371fd00a9c981206.jpg)

### 使用Docker套接字绑定
#### 服务器配置注册信息

    docker exec -it gitlab-runner gitlab-runner register \
               --non-interactive \
               --executor "docker" \
               --docker-image tico/docker \
               --docker-privileged \
               --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
               --docker-volumes /data/wwwroot:/var/www \
               --url "http://gitcode.com:8989/" \
               --registration-token "REGISTRATION_TOKEN" \
               --description "docker-runner-web002" \
               --tag-list "docker-runner-web002" \
               --run-untagged="true" \
               --locked="false" \
               --access-level="not_protected"


> 注: 注意tag必须是唯一的, 多台机器公用一个, 会随机在某一台机器执行, 而不会全部执行.

#### 搭配的.gitlab-ci.yml配置(需要放到项目根目录)


     image: docker:stable

     before_script:
       - docker info

     build:
       stage: build
       script:
         - docker build -t my-docker-image .
         - docker run my-docker-image /script/to/run/tests


#### **_成功_**
![成功](https://i.loli.net/2019/07/23/5d371fd00adf241936.png)

以上是整个项目配置的流程, 三种方式我都尝试了, 最终通过**第三种**方式实现.
