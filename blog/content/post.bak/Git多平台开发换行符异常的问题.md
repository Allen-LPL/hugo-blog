---
title: Git多平台开发换行符异常的问题
date: 2018-01-13 16:40:33
tags: [Git]
categories: [手艺]
---
Git 多平台换行符问题(LF or CRLF).
文本文件所使用的换行符，在不同的系统平台上是不一样的。UNIX/Linux 使用的是 0x0A（LF），早期的 Mac OS 使用的是 0x0D（CR），后来的 OS X 在更换内核后与 UNIX 保持一致了.
但 DOS/Windows 一直使用 0x0D0A（CRLF） 作为换行符.

<!-- more -->
# 描述问题
在多端开发的时候, 倘若windows端安装git时是这样勾选的
![Git多平台开发换行符异常的问题1.jpg](https://i.loli.net/2018/09/07/5b9243a7c45a1.jpg)
辣么, 恭喜你, 其他平台开发的代码就会从这样
![Git多平台开发换行符异常的问题2.png](https://i.loli.net/2018/09/07/5b9243a7a4234.png)
变成这样
![Git多平台开发换行符异常的问题3.png](https://i.loli.net/2018/09/07/5b9243a7c3b46.png)

# 解决方式

## 修改 git bash 配置

``` bash
# 提交时转换为LF，检出时不转换
git config --global core.autocrlf input
```

> 这样设置与安装时这个选项作用相同

![Git多平台开发换行符异常的问题4.jpg](https://i.loli.net/2018/09/07/5b9246db725a6.jpg)


## 其他相关的命令

``` bash
# 提交时转换为LF，检出时转换为CRLF
git config --global core.autocrlf true

# 提交检出均不转换
git config --global core.autocrlf false
```

# 其他
目前这种情况我只在Git Bash遇见过, 在cmder中是没有问题的, 所以也引起了我的注意, 这才有了这篇blog.

