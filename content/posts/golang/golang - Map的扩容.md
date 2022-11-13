---
title: golang 切片的扩容
date: 2021-01-12
tags: [Golang]
categories: [手艺]
---
Go Map选择的数据结构是哈希查找法, 为了解决碰撞问题, 使用了链表法. Map的扩容的衡量指标是**装载因子**, 公式为: loadFactor := count / (2^B), 
即 LoadFactor（装载因子）= hash表中已存储的键值对的总数量/hash桶的个数（即hmap结构中buckets数组的个数）

<!--more-->
# 触发扩容的条件
向map里插入新key时, 会进行条件检测, 符合下面两个条件, 就会触发扩容:
- 装载因子超过阈值 (强制为6.5)
- overflow的bucket数量过多:
  - 当B<15, 也就是bucket总数2^B小于2^15时, overflow的bucket数量超过2^B;
  - 当B>=15,也就是bucket总数2^B大于等于2^15, overflow的bucket数量超过2^15;

# 源码分析
> Go1.9版本   src/runtime/map.go 657行

## 触发扩容↓
```go
	// If we hit the max load factor or we have too many overflow buckets,
	// and we're not already in the middle of growing, start growing.
	if !h.growing() && (overLoadFactor(h.count+1, h.B) || tooManyOverflowBuckets(h.noverflow, h.B)) {
		hashGrow(t, h)
		goto again // Growing the table invalidates everything, so try again
	}
```

> Go1.9版本   src/runtime/map.go 1084行

## 装载因子超过6.5
```go
// overLoadFactor reports whether count items placed in 1<<B buckets is over loadFactor.
func overLoadFactor(count int, B uint8) bool {
return count > bucketCnt && uintptr(count) > loadFactorNum*(bucketShift(B)/loadFactorDen)
}
```

> Go1.9版本   src/runtime/map.go 1092行

## overflow bucket太多
```go
// tooManyOverflowBuckets reports whether noverflow buckets is too many for a map with 1<<B buckets.
// Note that most of these overflow buckets must be in sparse use;
// if use was dense, then we'd have already triggered regular map growth.
func tooManyOverflowBuckets(noverflow uint16, B uint8) bool {
	// If the threshold is too low, we do extraneous work.
	// If the threshold is too high, maps that grow and shrink can hold on to lots of unused memory.
	// "too many" means (approximately) as many overflow buckets as regular buckets.
	// See incrnoverflow for more details.
	if B > 15 {
		B = 15
	}
	// The compiler doesn't see here that B < 16; mask B to generate shorter shift code.
	return noverflow >= uint16(1)<<(B&15)
}
```

# 触发扩容两个条件的理解 
## 第一点
每个bucket有8个空位, 在没有溢出, 且所有的桶都装满了的情况下, 装载因子算出来的结果是8. 因此当装载因子超过6.5时, 表明很多bucket都快要装满了, 
查找, 插入和删除的效率都变低了, 在这个时候进行扩容是有必要的.

## 第二点
是对第一点的补充. 就是说在装载因子比较小的情况下, 这时候map的操作效率也很低, 而第一点却识别不出来. 表面现象就是计算装载因子的分子比较小, 
即map里元素总数少,但是bucket数量多, 真是分配的bucket数量多, 包括大量的overflow bucket

{{< admonition warning >}}
造成这种情况的原因是: 不停的插入和删除元素. 
先插入很多元素, 导致创建了很多的bucket, 但是装载因子达不到第一点的临界值, 没有触发扩容来缓解这种情况. 之后, 不断删除元素减少元素总数量, 
再插入很多元素, 导致创建了很多的overflow bucket, 单就是不会触发第一点的规定, 因为overflow bucket太多, key会很分散, 查找插入效率非常低, 
因此用第二点进行缓解.
{{< /admonition >}}

# 触发扩容两个条件的策略
## 第一点
对于第一点, 元素多, bucket数量少, 策略就简单:
> 将B加1, bucket总数(2^B)直接变成原来的2倍.

## 第二点
对于第二点, 元素少, overflow bucket数量多, 说明很多bucket都没有装满, 策略为:
> 开辟一个新的bucket空间, 将老bucket中的元素移动到新的bucket, 使同一个bucket的key排列的更加紧密

{{< admonition danger >}}
第二种策略有种极端情况: 如果插入map的key的哈希值一样, 都会落在同一个bucket里, 超过8个就会产生overflow bucket, 结果也会造成overflow bucket
数量过多. 
这将导致哈希表退化为链表, 操作效率为O(n).
{{< /admonition >}}

# 搬迁bucket
需要说明的是, map的扩容与搬迁不是一次性完成, 是分开完成的.
## 触发条件
在map执行插入, 修改和删除key操作时, 会先检查oldbuckets是否搬迁完毕, 具体来说就是判断oldbuckets是否为nil, 再来尝试进行搬迁buckets的工作
## 搬迁策略
为了不影响性能, map扩容采取了一种"渐进式"的方式, 原有的key不会一次性搬迁完毕, 每次最多搬迁2个bucket.
## 搬迁bucket结果描述
### 第一点
因为bucket数量增加, 需要重新计算key的哈希, 才能决定它落在哪个bucket.
### 第二点
因为bucket数量不变, 可以按照序号来搬迁