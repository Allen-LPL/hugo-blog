---
title: Linux服务器中git命令终端渲染出现问号
date: 2023-05-22 15:16:57
tags: [Linux]
categories: [手艺]
---
记录 Linux服务器中git命令终端渲染出现问号的原因及解决方案
<!--more-->

# 问题
![Linux服务器中git命令终端渲染出现问号](../vx_images/107905629951159_1.png)


# 原因

这是因为在错误信息中出现了非ASCII字符，导致编码问题，无法正确显示。

# 解决方案

可以尝试在命令行中设置编码为UTF-8, 比如在Debian11系统中可以使用以下命令设置终端编码为 UTF-8：
```shell
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
```

# 效果
![解决Linux服务器中git命令终端渲染出现问号](../vx_images/462725793899563_1.png)
