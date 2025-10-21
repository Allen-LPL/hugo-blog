---
title: MAC M1 使用docker的注意事项和docker代理的使用和系统代理的使用
date: 2022-11-27 00:02:08
tags: [Docker]
categories: [手艺]
---
太长时间没有做本地调试的事情了, 这个M1内核变更, 导致很多docker镜像出现异常, 又因为自己平时长期开着代理, 很容易的忽略了代理的影响.

<!--more-->

# 问题
## MAC M1 使用docker的注意事项及方案
当前时间节点, 2022年11月, 如果通过M1内核的MAC build 生成的镜像, 在使用的时候会出现各种异常, 比如我昨天遇到的openresty问题

![Xnip2022-11-28_00-15-39.png](https://s2.loli.net/2022/11/28/xp8IhEeQuliZsSJ.png "M1内核不好用啊")

## 解决方式
在编译的时候, 使用linux/amd64的内核

**方法:**
1. 在自己使用的终端配置 
```shell
export DOCKER_DEFAULT_PLATFORM=linux/amd64  
```

2. 在Dockerfile文件中配置
```dockerfile
FROM --platform=linux/amd64 openresty:v19
```

3. 在docker-compose.yml中配置
```docker-compose
    openresty:
      platform: linux/amd64
```

## 在docker的config.json中配置了代理, 会导致镜像内也被打入配置
我在[上上上...上某篇文章]中有介绍如何在Linux环境中配置docker的代理, 可以在Build的时候, 直接拉取全球的依赖, 
体验感超级棒, 只是没想到这里面有坑.

你如果在本地配置了*~/.docker/config.json*, 类似这种的
![Xnip2022-11-28_00-33-29.png](https://s2.loli.net/2022/11/28/IeJPSnkrFlU5dAm.png "docker 代理配置")
![Xnip2022-11-28_00-34-13.png](https://s2.loli.net/2022/11/28/qgiot4nfTONWeF2.png "docker inspect")
那在镜像里也会配置了代理的Env, **如果你的代理没出问题, 那就没问题, 一旦代理的地址变更或者代理挂了, 就会出莫名问题**

## 本地测试时候, 要注意系统代理的使用
在使用系统代理的时候, 如果没有指定域名直连的话, 它会在国内DNS查询不到的情况下, 直接推到隧道另一头, 这就导致本地配置的host, 
会一直出现莫名问题...

[上上上...上某篇文章]: http://www.liupengliang.com/linux-dockerfile-build%E6%97%B6%E8%AF%B7%E6%B1%82%E8%B6%85%E6%97%B6%E7%9A%84%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3/
