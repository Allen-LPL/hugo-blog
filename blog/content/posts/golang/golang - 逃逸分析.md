---
title: golang 逃逸分析与判断
date: 2020-08-18
tags: [Golang]
categories: [手艺]
---
Go语言逃逸分析最基本的原则是：如果一个函数返回对一个变量的引用， 那么这个变量就会发生逃逸

<!--more-->
# 发生原因
通俗来说， 所谓的逃逸是变量本来应该在堆上， 结果被分配到了栈上。
> 变量堆与栈的分配， 是编译器依据变量是否被外部引用进而来决定

- 如果变量在函数外部没有引用， 则优先放到栈上
- 如果变量在行数外部存在引用， 则必定放在堆上

举个🌰：
```golang
package main

import "fmt"

func foo() *int {
	t := 3
	return &t
}

func main() {
	x := foo()
	fmt.Println(x)
}

```

# 判断是否发生逃逸

## 使用编译器参数
> go build -gcflags '-m -l' main.go

![Xnip2022-11-11_19-34-29.png](https://s2.loli.net/2022/11/11/oEORtiyFsHP8M9d.png "使用-gcflags")

{{< admonition abstract >}}
-m 用于输出编译的优化细节
-N 用来关闭编译器优化
-l 用于禁止foo函数的内联优化
{{< /admonition >}}

## 使用tool
> go tool compile -S main.go

![Xnip2022-11-11_19-35-02.png](https://s2.loli.net/2022/11/11/PAThEHrcf9BamoR.png "使用tool")

{{< admonition >}}
上图标记出来的 *newobject* 用于在堆上分配一块内存
{{< /admonition >}}