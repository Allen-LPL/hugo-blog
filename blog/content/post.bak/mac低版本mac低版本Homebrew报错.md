---
title: mac低版本mac低版本Homebrew报错
date: 2020-01-03
tags: [Mac]
categories: [手艺]
---
mac系统低版本过低, 或者Homebrew长时间未更新过, 造成homebrew-core文件落后太多, 解决方案就是将homebrew-core文件删除, 重新
pull.
<!-- more -->

# 问题报错
![报错](https://s3.bmp.ovh/imgs/2022/07/19/9fbb987645eae6cb.png)

# 解决方式, 以下二选一, 或者都做
## 拉取浅层, 快速解决问题
```
cd /usr/local/Homebrew/Library/Taps/homebrew/
rm -rf homebrew-core
git clone https://github.com/Homebrew/homebrew-core.git --depth 1
cd homebrew-core/
git fetch --depth=300
```

## 完整拉取, 避免异常
```
git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
```