---
title: Ubuntu安装zsh && 默认启动
date: 2017-07-02 08:33:58
tags: [Zsh,Ubuntu]
categories: [手艺]
---
zsh拥有更强的补全功能(常用工具的参数补全), 推荐大家使用

<!--more-->
# 安装
`sudo apt-get install zsh`

# 引入增强插件,支持git,rails等补全，可选多种外观皮肤
`wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh`

# zsh作为默认shell，重启后生效
chsh -s /bin/zsh

# 参考文献
[ubuntu安装终极zsh](http://www.2cto.com/os/201208/145862.html])
