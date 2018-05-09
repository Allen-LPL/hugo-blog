---
title: 介绍一个oh-my-zsh的扩展Z实现跳转
date: 2017-07-02 18:26:53
tags: [oh-my-zsh,Linux]
categories: [手艺,工具]
---
oh-my-zsh是款常用的命令行工具, 他具有很多插件和扩展, 今天介绍一下Z.

<!-- more -->
#介绍
Z 不是 Oh-My-ZSH 的一部分，不过对任何苦于使用命令行的人来说它都是一个完美的搭配。Z 背后的想法是把你经常和最近 —— “Frecent” —— 访问的文件夹建成一个列表，然后允许你通过一行命令来快速的跳转，而不用在一个层层嵌套的目录结构中来回切换。

Z与AotuJump是一类的, 我之所以选择Z, 很大的原因是随着使用的时间线增加, AutoJump会越来越慢.

#安装
为了避免不必要的麻烦, 最简单的方式是从github直接下载源码
进入根目录
`bash
cd ~
`
下载Z扩展
`git
git clone https://github.com/rupa/z
`
将扩展在.zshrc进行注册
`bash
vim ~/.zshrc
`

在配置最下面写入
`bash
# include Z, yo
. ~/z/z.sh
`

激活修改
`bash
source ~/.zshrc
`

没有报错, 就代表安装完成.

