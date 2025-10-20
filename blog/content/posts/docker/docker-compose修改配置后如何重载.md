---
title: docker-compose修改配置后如何重载
date: 2022-11-26 23:47:14
tags: [Docker]
categories: [手艺]
---
docker-compose修改过配置文件后, 仅仅restart是不会生效的.

<!--more-->
# 方法
修改docker-compose.yml, 引入nginx.conf, 并修改nginx.conf的worker_processes为auto

![Xnip2022-11-27_23-53-42.png](https://s2.loli.net/2022/11/27/OrjqpnsZ8x9VDWI.png "修改docker-compose.yml") 

> docker-compose up --force-recreate -d openresty

![Xnip2022-11-27_23-49-34.png](https://s2.loli.net/2022/11/27/2yjbtJrF4c9CXhw.png "执行过程") 

![Xnip2022-11-27_23-55-08.png](https://s2.loli.net/2022/11/27/i5QOpLN14dvDwCR.png "查看效果")

**如图可见已变更**

# 问题
docker-compose修改过配置文件后, 仅仅restart是不会生效的. 要想加载配置, 以前只有两个方法
> docker-compose down

或者

> docker stop openresty && docker rm openresty

不管哪一种服务都会中断较长时间, 非常难受