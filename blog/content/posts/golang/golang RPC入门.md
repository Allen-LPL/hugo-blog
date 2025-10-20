---
title: golang RPC入门
date: 2019-01-02
tags: [Golang]
categories: [手艺]
---
Golang入门

<!--more-->

# RPC
## 定义
RPC是在分布式计算，远程过程调用（英语：Remote Procedure Call，缩写为 RPC）是一个计算机通信协议。在互联网时代，RPC已经和IPC一样成为一个不可或缺的基础构建。RPC是进程之间的通信方式（inter-process communication,IPC）不同的进程有不停的地址空间。

## 原理
一个正常的RPC过程可以分为下面几步：

client调用client stub，这是一个过程调用
client stub将参数打包成一个消息，然后发送这个消息，打包过程叫做marshalling
client所在的系统将消息发送给server
server的系统将收到的包传给server stub
server stub解包得到参数。解包也被称作unmarshalling
最后server stub调用服务过程，返回结果按照相反的步骤传给client
RPC只是描绘了 Client 与 Server 之间的点对点调用流程，包括 stub、通信、RPC 消息解析等部分，在实际应用中，还需要考虑服务的高可用、负载均衡等问题，所以产品级的 RPC 框架除了点对点的 RPC 协议的具体实现外，还应包括服务的发现与注销、提供服务的多台 Server 的负载均衡、服务的高可用等更多的功能。

## 类别
目前的 RPC 框架大致有两种不同的侧重方向，一种偏重于服务治理，另一种偏重于跨语言调用。

服务治理型的 RPC 框架有 Dubbo、DubboX、Motan 等，这类的 RPC 框架的特点是功能丰富，提供高性能的远程调用以及服务发现及治理功能，适用于大型服务的微服务化拆分以及管理，对于特定语言（Java）的项目可以十分友好的透明化接入。但缺点是语言耦合度较高，跨语言支持难度较大。

跨语言调用型的 RPC 框架有 Thrift、gRPC、Hessian、Hprose 等，这一类的 RPC 框架重点关注于服务的跨语言调用，能够支持大部分的语言进行语言无关的调用，非常适合于为不同语言提供通用远程服务的场景。但这类框架没有服务发现相关机制，实际使用时一般需要代理层进行请求转发和负载均衡策略控制。

## Show Code
> 默认跨语言, 使用json
### 初级版
创建两个文件夹, 分别命名为server, client. 在其下分别创建main.go文件
![1.png](https://s3.bmp.ovh/imgs/2022/08/05/af8705476d69329f.png "1")
- client
```go
package main

import (
	"fmt"
	"net"
	"net/rpc"
	"net/rpc/jsonrpc"
)

func main() {
	c, err := net.Dial("tcp", "localhost:9090")
	if err != nil {
		fmt.Println(err)
		return
	}

	client := rpc.NewClientWithCodec(jsonrpc.NewClientCodec(c))

	reply := ""
	err = client.Call("FoodService.SayName", "九转大肠", &reply)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(reply)
}
```

- server
```go
package main

import (
	"fmt"
	"net"
	"net/rpc"
	"net/rpc/jsonrpc"
)

type FoodService struct {
}

func (f *FoodService) SayName(request string, resp *string) error {
	*resp = "您点的菜是:" + request
	return nil
}

func main() {
	listen, err := net.Listen("tcp", ":9090")
	if err != nil {
		fmt.Println(err)
		return
	}

	err = rpc.RegisterName("FoodService", &FoodService{})
	if err != nil {
		fmt.Println(err)
		return
	}
	for true {
		conn, err := listen.Accept()
		if err != nil {
			fmt.Println(err)
			return
		}

		//rpc.ServeConn(conn)
		go rpc.ServeCodec(jsonrpc.NewServerCodec(conn))
	}

}
```

> rpc服务最多的优点就是可以像使用本地函数一样使用 远程服务上的函数, 因此有几个关键点:
- 远程连接: 类似于pkg
- 函数名称: 要表用的函数名称
- 函数参数: 这个需要符合RPC服务的调用签名, 及第一个参数是请求，第二个参数是响应
- 函数返回: rpc函数的返回是 连接异常信息, 真正的业务Response不能作为返回值

### 改进一版, 基于接口约束
> 上面是client call 方法, 里面3个参数2个interface{}, 你再使用的时候 可能真不知道要传入什么, 这就好像你写了一个HTTP的服务, 没有接口文档, 容易调用错误
为了避免这种情况， 可以对客户端进行一次封装, 使用接口当作文档, 明确参数类型

创建新文件夹 service
![2.png](https://s3.bmp.ovh/imgs/2022/08/05/f8fae7472be2f7e9.png "2")

service里的接口声明
```go
package service

const FoodServiceName = "FoodService.SayName"

type FoodService interface {
	SayName(request string, resp *string) error
}

```

在client添加接口约束
```go
package main

import (
	"fmt"
	"learn/5/5-5-1/service"
	"net"
	"net/rpc"
	"net/rpc/jsonrpc"
)

var _ service.FoodService = (*FoodServiceClient)(nil)

type FoodServiceClient struct {
	*rpc.Client
}

func (f FoodServiceClient) SayName(request string, resp *string) error {
	return f.Call(service.FoodServiceName, request, &resp)
}

func DialFoodService(network, address string) (*FoodServiceClient, error) {
	c, err := net.Dial(network, address)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	return &FoodServiceClient{Client: rpc.NewClientWithCodec(jsonrpc.NewClientCodec(c))}, nil
}

func main() {
	/*c, err := net.Dial("tcp", "localhost:9090")
	if err != nil {
		fmt.Println(err)
		return
	}

	client := rpc.NewClientWithCodec(jsonrpc.NewClientCodec(c))*/

	/*	reply := ""
		err = client.Call("FoodService.SayName", "九转大肠", &reply)
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println(reply)

	*/

	client, err := DialFoodService("tcp", "localhost:9090")
	if err != nil {
		fmt.Println(err)
		return
	}

	reply := ""
	fmt.Println(client.SayName("九转大肠", &reply))
	fmt.Println(reply)
}

```

在server中添加接口约束
```go
package main

import (
	"fmt"
	"learn/5/5-5-1/service"
	"net"
	"net/rpc"
	"net/rpc/jsonrpc"
)

type FoodService struct {
}

func (f *FoodService) SayName(request string, resp *string) error {
	*resp = "您点的菜是:" + request
	return nil
}

var _ service.FoodService = (*FoodService)(nil)

func main() {
	listen, err := net.Listen("tcp", ":9090")
	if err != nil {
		fmt.Println(err)
		return
	}

	err = rpc.RegisterName("FoodService", new(FoodService))
	if err != nil {
		fmt.Println(err)
		return
	}
	for true {
		conn, err := listen.Accept()
		if err != nil {
			fmt.Println(err)
			return
		}

		//rpc.ServeConn(conn)
		go rpc.ServeCodec(jsonrpc.NewServerCodec(conn))
	}

}

```

> 注: `var _ service.FoodService = (*FoodService)(nil)`这种形式, 是变量赋值的变体
> 类似于***`var VariableName variableType = variableValue`***

### 通过HTTP请求RPC协议
因为只需要是通过HTTP请求, 所以不需要client
![3.png](https://s3.bmp.ovh/imgs/2022/08/05/87f96b7b880dc336.png "3")
service代码不变
```go
package service

const FoodServiceName = "FoodService.SayName"

type FoodService interface {
	SayName(request string, resp *string) error
}

```

server代码调整
```go
package main

import (
	"io"
	"learn/5/5-5-1/service"
	"net/http"
	"net/rpc"
	"net/rpc/jsonrpc"
)

type FoodService struct {
}

func (f *FoodService) SayName(request string, resp *string) error {
	*resp = "您点的菜是:" + request
	return nil
}

var _ service.FoodService = (*FoodService)(nil)

func NewRPCReadWriteCloserFromHttp(w http.ResponseWriter, r *http.Request) *RPCReadWriteCloser {
	return &RPCReadWriteCloser{w, r.Body}
}

type RPCReadWriteCloser struct {
	io.Writer
	io.ReadCloser
}

func main() {
	rpc.RegisterName("FoodService", new(FoodService))
	http.HandleFunc("/jsonrpc", func(w http.ResponseWriter, r *http.Request) {
		conn := NewRPCReadWriteCloserFromHttp(w, r)
		rpc.ServeRequest(jsonrpc.NewServerCodec(conn))
	})

	http.ListenAndServe(":1234", nil)
}

```

#### 通过POSTMAN 或者 PAW请求
![4.png](https://s3.bmp.ovh/imgs/2022/08/05/1a82a46a48332f1e.png "4")


以上.