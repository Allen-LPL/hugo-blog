---
title: Ubuntu重启Nginx
date: 2017年8月3日 15:43:31
tags: [Nginx,Ubuntu]
categories: [手艺]
---
ubuntu操作系统重启nginx的操作

<!-- more -->
# 正文
`
    ps -ef |grep nginx
`

<img src="/uploads/images/Ubuntu重启Nginx/ubuntu重启nginx-查看进程.png" width="400" height="400">

首先查看nginx在系统中的进程


`
    kill -9 2127
`
结束nginx进程

-----

开启nginx
`
/usr/local/nginx/sbin/nginx
`

重启nginx
`
/usr/local/nginx/sbin/nginx -s reload
`

-----

开启php5.6
`
    /etc/init.d/php-fpm56 start
`

