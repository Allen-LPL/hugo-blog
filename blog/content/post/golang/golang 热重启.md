---
title: golang热重启
date: 2018-04-02
tags: [Golang]
categories: [手艺]
---
golang的热重启, 分为及时更新与进程重启

<!-- more -->

# 开发
## fresh的应用
> go get github.com/pilu/fresh

- 直接在项目中启动
`
    fresh
`

# 生产
## 热重启服务

- [facebookgo/grace](https://github.com/facebookarchive/grace) - Graceful restart & zero downtime deploy for Go servers.
- [fvbock/endless](https://github.com/fvbock/endless) - Zero downtime restarts for go servers (Drop in replacement for http.ListenAndServe)
- [jpillora/overseer](https://github.com/jpillora/overseer) - Monitorable, gracefully restarting, self-upgrading binaries in Go (golang)

> 详情: https://learnku.com/articles/23505/graceful-restart



