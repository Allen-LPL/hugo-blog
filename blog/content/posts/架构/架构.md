---
title: etcd和etcdKeeper的docker-compose的使用
date: 2023-02-24 20:35:04
tags: [架构]
categories: [手艺]
---
使用docker-compose编排etcd和etcdKeeper

<!--more-->

## 鉴权
```
# 创建一个用户alice --user和--passwd输入root和root的密码
$ etcdctl --user xxx --passwd xxx user add alice
New password:
# 创建一个角色foo
$ etcdctl role add foo
# 将foo角色赋予alice用户
$ etcdctl user grant-role alice foo
# 将/foo/开头的key的读写权限赋予foo角色
$ etcdctl role grant-permission foo readwrite /foo/
```