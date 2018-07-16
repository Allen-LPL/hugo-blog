---
title: docker的清理
date: 2017-08-01 14:55:01
tags: [docker]
---

# 命令介绍
docker在使用的过程中会不断的累积images，docker v1.13版本之后，提供了清理的命令
`
docker system prune
`
**docker system prune**命令可以用于清理磁盘，删除关闭的容器、无用的数据卷和网络，以及dangling镜像(即无tag的镜像)


`
docker system prune -a
`
**docker system prune** -a命令清理得更加彻底，可以将没有容器使用Docker镜像都删掉

# 场景复现
`bash
docker images
`

| REPOSITORY  | TAG  | IMAGE ID | CREATED | SIZE |
|:------------- |:---------------:| -------------:| -------------:| -------------:|
| liupengliang/hugo        | liupengliang/hugo 			 |         c043eef07c92 | 2 days ago | 28.6MB
| docker_mysql      | latest        |           ec1fc3b9f0d6 | 2 days ago | 327MB
| docker_redis | latest        |            b69017f88f53 | 4 days ago | 256MB

查询docker的磁盘使用情况：
`
docker system df
`

	TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE	Images              16                  5                   1.847GB             1.514GB (81%)	Containers          10                  5                   1.015kB             12B (1%)	Local Volumes       24                  0                   0B                  0B	Build Cache                                                 0B                  0B


执行命令
`
docker system prune -a
`

再次查询docker的磁盘使用情况：
`
docker system df
`

	untagged: docker_redis:latest
	deleted: sha256:37ae69b7c971c8TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE	Images              5                   5                   1.185GB             4.148MB (0%)	Containers          5                   5                   1.003kB             0B (0%)	Local Volumes       24                  0                   0B                  0B	Build Cache   fde28e0edbdbbac919ca50aec45ce09104e6860e02891b23cb
	deleted: sha256:d0667bcff715caca2ccc3b59470af77903ec148d791873cb15332496b49fbe5f
	deleted: sha256:0f57644645eb53a3d2256f460ade116ad3590252c28f63e5136c026423dc8286
	deleted: sha256:e764f01ed6db22c32281d8039af4ea6f30034d71874c914ea2226f554c856ac0
	deleted: sha256:708c19d6f3b9780b92ee92f64aef616eeb95c8b9310da615b909e57cb3713623
	deleted: sha256:6c6ac3752f6748e1927ebb1276779835f8d7e8a43839cec2cdc9f85c2d92a76b
	deleted: sha256:06daed77f1be888e79a41dfa02e813fd6c0292ce6b4384faf0cdb8b45bd7d85e
	deleted: sha256:ba9c00316844a69c13b225f20b4d928345dcae9023475290c0cd1012ed68afd5
	deleted: sha256:053ba64becb4ca5ea795545d784ef8f73e20172469f732390e7913bc2163a381
	deleted: sha256:77a8f539af903fc3acb3b4b6e48213f69303396ed2b35617aadc71d21c008a29
	deleted: sha256:7909b93d6ad35e81f4b5403f2a7ebe8ac2693a4b9cc208b3b4b0788f4c24430e
	deleted: sha256:d0ff786c46ced28bd1bad2236ec5db0690443f506d8482c2246f498d33514ab6
	

