---
title: vps上搭建hexo轻博客
date: 2017-03-15 21:15:22
tags:
 - VPS
 - Hexo
 - Git

---
vps搭建个人轻博客的思路大致为: 本地使用hexo生成静态页面, 将本地静态页面通过hexo的deploy(部署)到VPS的git私有仓库中, 再通过git hooks(git 钩子)同步到web根目录
<!-- more -->

# 前言
***
这是我的第一篇博客, 本篇主讲我在VPS服务器上搭建博客的过程, 包括自己在搭建博客中遇到的问题与感悟.
# 目标
***
在VPS服务器中搭建个人博客.
# 前期准备
***
- VPS服务器
>我的VPS服务器是购买的 [搬瓦工][搬瓦工]服务器

- 本地环境
>windows 或者 linux

# 正文
***
## 本地配置
### 安装
- [GIT][GIT]
- [NODE.JS][NODE.JS]
- [HEXO][HEXO]

### 本地操作
- [GIT生成SSH密钥][GIT生成SSH密钥]
- [初始化HEXO][安装HEXO]

## VPS配置
### 安装
- [GIT][GIT]
- [NODE.JS][NODE.JS]
- [NGINX][NGINX]

### VPS操作
#### 初始化用户
- 新建git用户, 并赋予sudo权限
{% codeblock %}
	adduser git  # 创建 git 用户
	chmod 740 /etc/sudoers
	vim /etc/sudoers
{% endcodeblock  %}

- 在vi编辑中找到如下内容：
```
	##Allow root to run any commands anywhere
	root    ALL=(ALL)     ALL
```

- 把刚才新建的用户下面同样格式添加一行就变成
```
	## Allow root to run any commands anywhere
	root    ALL=(ALL)     ALL
	git   ALL=(ALL)     ALL
```
- 保存并退出后执行
```
chmod 440 /etc/sudoers
```

#### 创建git仓库，并配置ssh登录
```
	su git
	cd ~
	mkdir .ssh && cd .ssh
	touch authorized_keys
	vi authorized_keys//在这个文件中粘贴进刚刚申请的key（在id_rsa.pub文件中）
	cd ~ 
	mkdir hexo.git && cd hexo.git
	git init --bare
```
_测试一下_
>在git bash中输入 ssh git@VPS的IP地址, 如果能够远程登录的话, 则表示设置成功.
>[链接不成功的调试][链接不成功的调试]

#### 创建网站目录并赋予git对网站目录的所有权
```
cd /var/www
mkdir hexo
chown git:git -R /var/www/hexo
```
#### 配置git hooks
```
su git
cd /home/git/hexo.git/hooks
vim post-receive
```
输入如下内容后保存退出
```
#!/bin/bash
GIT_REPO=/home/git/hexo.git #git仓库
TMP_GIT_CLONE=/tmp/hexo
PUBLIC_WWW=/var/www/hexo #网站目录
rm -rf ${TMP_GIT_CLONE}
git clone $GIT_REPO $TMP_GIT_CLONE
rm -rf ${PUBLIC_WWW}/*
cp -rf ${TMP_GIT_CLONE}/* ${PUBLIC_WWW}
```
然后赋予脚本的执行权限
```
chmod +x post-receive
```
#### 配置Nginx
```
vim /etc/nginx/conf.d/hexo.conf

插入如下代码：
server {
    listen         80 ;
    root /var/www/hexo;//这里可以改成你的网站目录地址，我将网站放在/var/www/hexo
    server_name example.com www.example.com;//这里输入你的域名或IP地址
    access_log  /var/log/nginx/hexo_access.log;
    error_log   /var/log/nginx/hexo_error.log;
    location ~* ^.+\.(ico|gif|jpg|jpeg|png)$ {
            root /var/www/hexo;
            access_log   off;
            expires      1d;
    }
    location ~* ^.+\.(css|js|txt|xml|swf|wav)$ {
        root /var/www/hexo;
        access_log   off;
        expires      10m;
    }
    location / {
        root /var/www/hexo;//这里可以改成你的网站目录地址，我将网站放在/var/www/hexo
        if (-f $request_filename) {
            rewrite ^/(.*)$  /$1 break;
        }
    }
}
```
重启Nginx
```
service nginx restart
```

## 本机的最后配置
### 配置hexo配置文件
位于hexo文件夹下，**_config.yml**,修改*deploy*选项

```
deploy:
  type: git
  message: update
  repo:
    s1: git@VPS的ip地址或域名:git仓库地址,master
##例如
deploy:
      type: git
      message: update
      repo:
    	s1: git@192.234.35.236:hexo.git,master
```

接着在hexo文件夹内，按住shift右击，选择在此处打开命令窗口（当然你也可以用cd命令），运行hexo g hexo d，如果一切正常，静态文件已经被成功的push到了blog的仓库里，如果出现appears not to be a git repo的错误，删除hexo目录下的.deploy后再次hexo g hexo d就可以了。

以上，博客已经完全建好了。



[搬瓦工]: https://bandwagonhost.com/ "搬瓦工"
[GIT]: https://git-scm.com/download/win "git的安装"
[NODE.JS]: https://nodejs.org/ "node.js的安装"
[HEXO]: https://nodejs.org/ "hexo的安装"
[GIT生成SSH密钥]: https://nodejs.org/ "GIT生成SSH密钥"
[安装HEXO]: https://nodejs.org/ "安装HEXO"
[NGINX]: https://nodejs.org/ "安装nginx"

[链接不成功的调试]: {% post_link 远程登录服务器 远程登录服务器 %} "链接不成功的调试"