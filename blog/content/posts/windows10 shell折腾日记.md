---
title: windows10 shell折腾日记
date: 2017-07-06 09:46:05
tags: [Shell, oh-my-zsh, Babun]
categories: [手艺]
---

无法忍受windows的cmd, powershell的低效, 对于windows-git-bash如果在不配置git alias的情况下, 依旧是难以忍受, 故, 折腾window10可用的, 好用的shell
<!--more-->
# 前言 #
说起为什么折腾windows10的shell, 就牵扯到了我用于工作的开发环境 ***virtualBox + vagrant + homestead***,
这套环境, 在我使用的过程中, 出现了 *git status* 获取困难的情况, 会有非常严重的卡顿! 让人无法忍受, 就开始想解决方式

# 正文 #
## **获取git状态时发生的卡顿** 起因分析
- 猜测是虚拟机到windows通信有问题
- oh-my-zsh 插件获取git status时有问题... 嗯, 道听途说的, 具体是哪里不清楚.
## 解决方式
 - 虚拟机中在linux端处理
    为了解决window到Linux的映射问题, 引入samba, 完美解决卡顿现象, 但是会有虚拟机启动以后映射盘还没有开启的情况,
    以及如果不开启虚拟机, 就无法打开映射盘, 这好似给自己加了个金箍... 此处不表
 - window端处理
    * window-git-bash 通过配置git alias, 基本可以支持自己的业务需求, 但是需要自己配置, 而且吧... 哈哈哈, 用过了oh-my-zsh
    以后, 对这个已无爱.

    * babun 完美解决问题

## babun介绍
> **使用babun无需管理员权限**
  先进的安装包管理器(类似于linux上面的apt-get或yum)
  预先配置了Cygwin和很多插件
  拥有256色的兼容控制台
  HTTP(S)的代理支持
  面向插件的体系结构
  可以使用它来配置你的git
  集成了oh-my-zsh
  自动升级
  支持shell编程，内置VIM等

> **Cygwin**
  babun的核心包括一个预配置的Cygwin。cygwin是一个非常好的工具，但有很多使用技巧，使你能够节省大量的时间。babun解决了很多问题，它里面包含了很多重要的软件包，是你能够第一时间能够使用它们。

> **包的管理**
  babun的包管理在shell输入：pact，这类似于：apt-get或yum，来非常方便的管理软件包，安装、升级、搜索和删除，让你省区很多麻烦，shell输入pact —help能够获得帮助信息。

> **shell**
  babun的shell通过调整，已达到最佳的用户体验，babun有两个配置之后马上使用的shell(默认使用zsh)，babun的shell具有以下的特点
  语法高亮
  具有unix的工具
  软件开发工具
  git-语义提示
  自定义脚本和别名
  等等………

> **Console**
  babun支持HTTP代理，只需添加地址和HTTP代理服务器的凭据。babunrc文件所在文件夹执行源babunrc启用HTTP代理。目前还不支持SOCKS代理。

> **开发者工具**
  babun提供多种方便的工具和脚本，是你的开发工作更轻松，具有的功能如下
  编程语言(python,Perl, etc等)
  git(各种各样的别名调整)
  UNIX工具((grep, wget, curl, etc)
  vcs (svn, git)
  oh-my-zsh
  自定义脚本(pbcopy, pbpaste, babun, etc)

## babun的安装
安装非常简单, 直接去[babun](http://babun.github.io/)官方上下载压缩包, 解压缩后执行install.bat文件, 即可使用.

# 坑
在使用的过程中, 会出现这种
    - 0 [main] fish 6020 child_info_fork::abort: C:\Users\me\.babun\cygwin\bin\cygncursesw-10.dll:
          Loaded to different address: parent(0xA80000) != child(0x580000)
      Could not create child process - exiting
      fork: unknown error (errno was 11)

**[解决方式](https://stackoverflow.com/questions/9300722/cygwin-error-bash-fork-retry-resource-temporarily-unavailable)**

# 资料
- [资料一](https://github.com/babun/babun/issues/477)
- [资料二](https://github.com/babun/babun/issues/558)




