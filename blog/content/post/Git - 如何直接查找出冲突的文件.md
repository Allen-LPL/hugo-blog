---
title: Git - 如何直接查找出冲突的文件
date: 2019-09-04 16:55:56
tags: [Git]
categories: [手艺]
---
    在项目中, 在合并其他分支的时候, 总会遇到合并大量文件, 其中有一两个文件有冲突, 那怎么在茫茫多的修改分支中查找到冲突的文件是本文解决的问题

<!-- more -->

# 前言
    在项目中, 在合并其他分支的时候, 总会遇到合并大量文件, 其中有一两个文件有冲突, 那怎么在茫茫多的修改分支中查找到冲突的文件是本文解决的问题
    通常我们在查看文件状态是通过`git status`, 但是在修改的文件超过的情况下, 是很难准确找到冲突的文件. 
    
![Git - 如何直接查找出冲突的文件.png](https://i.loli.net/2019/09/04/aezHZ5kSsJgqIhT.png)


# 出招
```
git diff --name-only --diff-filter=U
```



