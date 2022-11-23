---
title: Git - 版本控制指令
date: 2017-06-13 16:40:33
tags: [Git]
categories: [手艺]
thumbnail: "/uploads/images/Git版本控制指令/gitLimit.png"
---

版本控制指令一些简单记录

<!--more-->

# 过滤命令
git版本过滤配置文件：


```
git update-index --assume-unchanged <your files>

example:

git update-index --assume-unchanged common/constant/Init.cnt.php
```


---

# 取消过滤配置
```
git update-index --no-assume-unchanged <files>

```



---

# zsh链接git卡顿
```
git config --global oh-my-zsh.hide-status 1
```


