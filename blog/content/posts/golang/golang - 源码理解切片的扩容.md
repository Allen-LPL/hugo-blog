---
title: golang 切片的扩容
date: 2021-01-12
tags: [Golang]
categories: [手艺]
---
切片结构的本质是对数组的封装, 那么切片的容量是怎么增长的?

<!--more-->
# 源码分析
> Go1.9版本   src/runtime/slice.go 178行

```go
func growslice(et *_type, old slice, cap int) slice {
	// ......

	// 这里计算了扩容的数量
	// 这里的if else判断, 整体表达的意思是:
	// 1. 当原slice容量小于1024的时候, 新slice容量变成原来的2倍
	// 2. 当原slice容量超过1024的时候, 新slice容量变成原来的1.25倍
	newcap := old.cap
	doublecap := newcap + newcap
	if cap > doublecap {
		newcap = cap
	} else {
		const threshold = 256
		if old.cap < threshold {
			newcap = doublecap
		} else {
			for 0 < newcap && newcap < cap {
				newcap += (newcap + 3*threshold) / 4
			}
			if newcap <= 0 {
				newcap = cap
			}
		}
	}

	// ........
	// 以下部分重点内容是
	// capmem = roundupsize(capmem) 这里的意思是做内存对齐
	// 这样就导致newcap都会被重新计算
	switch {
	case et.size == 1:
		lenmem = uintptr(old.len)
		newlenmem = uintptr(cap)
		capmem = roundupsize(uintptr(newcap))
		overflow = uintptr(newcap) > maxAlloc
		newcap = int(capmem)
	case et.size == goarch.PtrSize:
		lenmem = uintptr(old.len) * goarch.PtrSize
		newlenmem = uintptr(cap) * goarch.PtrSize
		capmem = roundupsize(uintptr(newcap) * goarch.PtrSize)
		overflow = uintptr(newcap) > maxAlloc/goarch.PtrSize
		newcap = int(capmem / goarch.PtrSize)
	case isPowerOfTwo(et.size):
		var shift uintptr
		if goarch.PtrSize == 8 {
			shift = uintptr(sys.Ctz64(uint64(et.size))) & 63
		} else {
			shift = uintptr(sys.Ctz32(uint32(et.size))) & 31
		}
		lenmem = uintptr(old.len) << shift
		newlenmem = uintptr(cap) << shift
		capmem = roundupsize(uintptr(newcap) << shift)
		overflow = uintptr(newcap) > (maxAlloc >> shift)
		newcap = int(capmem >> shift)
	default:
		lenmem = uintptr(old.len) * et.size
		newlenmem = uintptr(cap) * et.size
		capmem, overflow = math.MulUintptr(et.size, uintptr(newcap))
		capmem = roundupsize(capmem)
		newcap = int(capmem / et.size)
	}

	// ......
}
```
{{< admonition warning >}}
通过源码可以看出以下说法不一定准确
1. 当原slice容量小于1024的时候, 新slice容量变成原来的2倍
2. 当原slice容量超过1024的时候, 新slice容量变成原来的1.25倍
{{< /admonition >}}

通过以下程序来验证:
```go
package main

import "fmt"

func main() {
	s := make([]int, 0)
	oldCap := cap(s)
	for i := 0; i < 2048; i++ {
		s = append(s, i)
		newCap := cap(s)
		if newCap != oldCap {
			fmt.Printf("[%d -> %4d] cap = %-4d | after append %-4d cap = %-4d\n", 0, i-1, oldCap, i, newCap)
			oldCap = newCap
		}
	}
}
```
运行结果:
```
[0 ->   -1] cap = 0    | after append 0    cap = 1   
[0 ->    0] cap = 1    | after append 1    cap = 2   
[0 ->    1] cap = 2    | after append 2    cap = 4   
[0 ->    3] cap = 4    | after append 4    cap = 8   
[0 ->    7] cap = 8    | after append 8    cap = 16  
[0 ->   15] cap = 16   | after append 16   cap = 32  
[0 ->   31] cap = 32   | after append 32   cap = 64  
[0 ->   63] cap = 64   | after append 64   cap = 128 
[0 ->  127] cap = 128  | after append 128  cap = 256 
[0 ->  255] cap = 256  | after append 256  cap = 512 
[0 ->  511] cap = 512  | after append 512  cap = 848 
[0 ->  847] cap = 848  | after append 848  cap = 1280
[0 -> 1279] cap = 1280 | after append 1280 cap = 1792
[0 -> 1791] cap = 1792 | after append 1792 cap = 2560

```

{{< admonition success >}}
当老s容量小于1024的时候, 新s的容量的确是老s的2倍
{{< /admonition >}}

{{< admonition failure >}}
当老s的容量大于等于1024的时候, 计算出来的倍数并不是1.25倍, 会比1.25大一些
{{< /admonition >}}