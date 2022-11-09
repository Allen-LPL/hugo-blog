---
title: 在PHPSTORM中使用cmder
date: 2018-01-16 09:10:03
tags: [PHPSTORM, CMDER]
categories: [手艺]
---
windows平台 PHPSTORM 中自带的命令终端是cmd, 之前我使用过git bash, 这个配置起来很简单, 这里就不赘述, 本文主要讲一下我配置cmder的过程

<!--more-->
# 配置环境变量
![在PHPSTORM中使用cmder1.png](https://i.loli.net/2018/09/07/5b924c2bc3fa2.png)

# 配置PHPSTORM的Terminal设置
![在PHPSTORM中使用cmder2.png](https://i.loli.net/2018/09/07/5b924c2bd2076.png)

我使用的PHPSTORM版本是 ***PHPSTORM 2017.2.5*** 配置命令
` "cmd.exe" /k ""%CMDER_ROOT%\vendor\init.bat"" `

倘若你的PHPSTORM是 **低于** 我的版本, 那么上面的命令可能会导致无法正常开启, 如果是这样, 那就尝试一下下面的命令
` cmd.exe /k ""%CMDER_ROOT%\vendor\init.bat"" `

> 出现这个问题, 主要是因为PHPSTORM版本的问题

# 效果
![在PHPSTORM中使用cmder3.png](https://i.loli.net/2018/09/07/5b924c2ba2744.png)