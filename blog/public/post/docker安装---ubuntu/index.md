经过了在window10安装docker的摧残后, 准备来linux系统找找自信

<!-- more -->
# 知识背景
 - 2013-3诞生了docker
 - linux内核3.8以上的系统才能支持docker, 只有一个特例(RHEL/Centos), 内核版本2.6.32-431的RHEL/Centos6.5才开始支持docker
 - docker 在Ubuntu下诞生, 是对docker支持最好的操作系统.
 - 随着RHEL/Centos对于docker的支持力度逐渐加大, 对于系统稳定性有比较高要求的生产环境, 还是推荐使用RHEL/Centos.
 - CoreOS是为docker而生的操作系统, 除了对docker有良好的支持外, 还集成了etcd, fleet等, 方便了对docker的集中管理,
 - CoreOS推出了自家的类docker的容器 -- rocket

 > 操作系统必须是64位才能支持docker

 # 配置环境
 我选择的开发环境是 *virtualBox* + *vagrant* + *homestead* + *docker* + *laraDock*
 此处只讲述docker配置

 # 开始配置
 - 更新apt软件源
    `sudo apt-get update`

 - 安装docker
    有两种方式:
        方法一: 从apt源安装docker.io, 但是一般版本比较旧
            `sudo apt-get install docker.io`
        方法二: 使用官方的安装脚本(推荐)
            `sudo apt-get install curl
             curl -sSL https://get.docker.com/ | sh
            `

 - 开启服务
    安装完以后, 开启docker守护进程
    `sudo service docker start
     docker start/running. process 3050
    `

 - 测试
    使用命令
    `sudo docker run hello-world`
    拉取hello-world 镜像并输出
    会显示一堆代码, 其中包括**Hello from Docker**

 - 赋予sudo权限
    如果不想每次执行docker时都要使用sudo权限, 可以把用户添加到Docker组中, 例如,
    我用的vagrant , 默认用户就是vagrant , 那我可以这么执行
    `sudo usermod -aG docker vagrant`

# 参考文献
<循序渐进学Docker>, 作者: 李金榜, 尹烨, 刘天斯, 陈纯. 出版社: 机械工业出版社.

