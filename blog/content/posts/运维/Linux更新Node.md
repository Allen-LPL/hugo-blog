---
title: Linux更新Node
date: 2017-04-25 10:55:20
tags: [Laravel, Homestead, Node]
categories: [手艺]
---
记录 **Laravel Homestead** 在vagrant中更新Node
<!--more-->

```
sudo npm cache clean -f
sudo npm install -g n (安装node的版本控制"n")
```
- 更新最新的版本
```
sudo n stable ()
```

- 更新指定的版本
```
sudo n v6.10.2
```