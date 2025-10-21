---
title: Grafana 里地图插件worldmap-panel无法读取地图图片的解决方法(实测有效)
date: 2019-11-26
tags: [Grafana]
categories: [手艺]
---
近期grafana的worldmap-panel出现无法显示地图，或者加载非常缓慢，显示不完整, 以下是解决方式.

<!--more-->

# 问题
Grafana 里地图插件worldmap-panel加载地图缓慢, 主要是因为加载的图片获取缓慢. 主要是以下两个图片地址
```
    https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png
    https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png

```


# 解决
备份三个文件，然后开始修改
```
grafana-worldmap-panel\src\worldmap.ts
grafana-worldmap-panel\dist\module.js
grafana-worldmap-panel\dist\module.js.map



将：https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png
替换成：http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png
将：https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png
替换成：http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png
```


> 资料来源: https://www.popyone.com/post/26.html



