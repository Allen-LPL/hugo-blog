---
title: Uxc项目部署
date: 2019-04-02
tags: [Uxc]
categories: [管理]
---
Uxc的搭建

<!-- more -->
> /zhongjl:dacong575


# blog
> docker run --name my-hugo -d -v $(pwd):/hugo-site -p 80:1313 --rm -it liupengliang/hugo-docker:latest

# ssr
> docker run --privileged -d -p 1919:1919/tcp -p 1919:1919/udp --name ssr-bbr-docker-1 letssudormrf/ssr-bbr-docker -p 1919 -k qweqwe -m aes-128-ctr -O auth_aes128_sha1 -o http_post

# v2ray
> 可以详细查看《Linux Dockerfile build时请求超时的问题解决》

# athens 搭建golang私包
> docker run -d -v /root/athens-storage:/var/lib/athens  -e ATHENS_DISK_STORAGE_ROOT=/var/lib/athens -e ATHENS_STORAGE_TYPE=disk  --name athens-proxy  --restart always -p 3000:3000    gomods/athens:v0.3.0uri


