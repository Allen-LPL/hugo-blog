---
title: windows10 shell折腾日记 ( 二 )
date: 2018-05-04 19:30:24
tags: [Shell, oh-my-zsh, Babun]
categories: [手艺]
---
折腾了一圈MAC, 现在是MAC+Windows双环境开发, 因为中了MAC oh-my-zsh的毒, 感觉不弄好windows的环境, 就浑身不得劲
<!--more-->
# 前言 #
以下是使用cmder + babun + oh-my-zsh遇到的问题
# 正文 #
## **启动zsh时会报以下错误**
    > compdef: unknown command or service: git

![1.png](https://i.loli.net/2020/04/18/4W2bCzE5L6vl91h.png "1.png")

## **解决** 
执行以下命令
``` shell
rm -f ~/.zcompdump
rm -f ~/.zcompdump-$(hostname)-5.0.6
compinit
cp ~/.zcompdump .zcompdump-$(hostname)-5.0.6
```
如下图
![2.png](https://i.loli.net/2020/04/18/6bjLSsX8TxUoyui.png "2.png")
![3.png](https://i.loli.net/2020/04/18/ILUyDHFrgXj5fPs.png "3.png")






