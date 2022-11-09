---
title: golang-gin-gorm链接数据库问题
date: 2018-03-21 21:47:03
tags: [Golang, Gin, Gorm]
categories: [手艺]
---

在练习使用gin - gorm链接数据库时, 始终出现报错, 最终发现是时区和Sprintf的问题

<!--more-->

# 问题还原
## 问题描述
查询和修改数据库都一直处于失败状态

> sql: database is closed

逐一排查问题, 发现是配置的问题:
![1](https://i.loli.net/2019/06/16/5d0614f22ef1b44094.png)

# 解决
修改掉Sprintf的影响

![2](https://i.loli.net/2019/06/16/5d0614f1855a453126.png)

