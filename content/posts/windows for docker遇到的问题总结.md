---
title: windows for docker遇到的问题总结
date: 2018-11-20 23:00:10
tags: [Docker]
categories: [手艺]
---
docker现在对于windows平台的支持越来越好, 我在windows环境开发的时候, 都是通过docker作为开发环境, 现整理汇总平时遇到的问题及解决方案, 供大家参考.
<!--more-->

# 问题
## 通过容器执行命令时报错
> the input device is not a TTY.  If you are using mintty, try prefixing the command with 'winpty'

## 解决
因为我是使用docker-compose编排, 起初以为是docker-compose的原因, 尝试了docker exec, 还是不行, 那就不是docker的原因, 不能简单粗暴的解决问题, 认真读了一下报错, :-O
竟然是让我在前面加*winpty*

![2.1.png](https://i.loli.net/2020/04/18/8VBRXQnGwYUqv5t.png)

***你个老头坏得很, 我差点就信了你!!!!!***

看来问题应该又要扩大化处理, 那就google一下, 找到了问题原因是这个
>It's a long standing issue with Docker. The way it does terminal detection only works with cmd.exe and powershell.exe at the moment. Any third-party terminal breaks that detection and gives the message.

翻一下是:
>Docker是一个长期存在的问题。目前，它执行终端检测的方式仅适用于cmd.exe和powershell.exe。任何第三方终端都会中断该检测并给出消息。

那就用powershell.exe试一下,

![2.2.png](https://i.loli.net/2020/04/18/VI7TU6kjdKGqEYn.png)

搞定!
