---
title: PHP7多进程处理redis队列问题
date: 2018-10-18 10:55:20
tags: [Yii2, PHP7, REDIS]
categories: [手艺]
---
一直在研究PHP7多进程编程, 在使用的过程中遇到了一些问题.
<!-- more -->
<The rest of contents | 余下全文>

# 问题
## redis 句柄问题
### 问题介绍
在使用PHP框架YII2进行多进程编程时, 在循环从redis list弹出数据时, 
![PHP7多进程处理redis队列问题1.png](https://i.loli.net/2018/10/20/5bcabff792a32.png)

出现了数据异常.
![PHP7多进程处理redis队列问题.png](https://i.loli.net/2018/10/20/5bcabff76f722.png)

### 分析
问题大概率出现在多个进程使用同一个redis 句柄的问题, 比如:
A进程获取了redis list的一个数据
B进程再去获取同一个数据时, 会获得 TRUE
C进程又去获取同一个数据, 就只能获得redis的数据存储号 (这个地方是我猜测)

### 解决
考虑好情况后, 在代码中
![PHP7多进程处理redis队列问题4.png](https://i.loli.net/2018/10/20/5bcabff792b6d.png)
修改后
![PHP7多进程处理redis队列问题5.png](https://i.loli.net/2018/10/20/5bcace2f1b590.png)

最后数据变为:
![PHP7多进程处理redis队列问题2.png](https://i.loli.net/2018/10/20/5bcabff78bd24.png)

### 总结
必须每个进程单独创建redis/mysql连接，其他的存储客户端同样也是如此。原因是如果共用1个连接，那么返回的结果无法保证被哪个进程处理。持有连接的进程理论上都可以对这个连接进行读写，这样数据就发生错乱了。

所以在多个进程之间，一定不能共用连接


## 多进程并发写入mysql遇见死锁的问题

### 问题介绍

在使用PHP多进程编程的过程中, 有次发现在并发多进程写入过程中, 出现死锁情况

![多进程死锁1.png](https://i.loli.net/2018/10/20/5bcb15f644f77.png)

### 分析
在网上找到了问题的情况
![多进程死锁.png](https://i.loli.net/2018/10/20/5bcb15f605c31.png)
简单描述就是, A进程执行写入时锁了行, B进程也要执行操作并且锁行, 但是锁不了, 就报错了.

### 解决
![多进程死锁2.png](https://i.loli.net/2018/10/20/5bcb174a0afb6.png)

### 总结
我的处理方式是, 先用索引查询, 然后再用主键进行修改, 这样确实不会出现死锁的问题, 但是又设计到了**脏数据**


