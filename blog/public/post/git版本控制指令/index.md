<img src="/uploads/images/Git版本控制指令/gitLimit.png" width="400" height="400">

<!-- more -->

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


