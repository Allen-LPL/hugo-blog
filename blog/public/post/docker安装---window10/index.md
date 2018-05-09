昨天准备重新布置自己的开发环境, 顺便练一下docker的安装, 就先尝试了window10的安装, 安装的过程中, 有各种各样的坑, 搏斗了一天后, 以放弃告终.
此处记录了正常的常规流程, 希望对其他人有帮助.

<!-- more -->

# 安装步骤
 - 到官网 https://www.docker.com/toolbox 下载Docker Toolbox.
 - 双击 Docker Toolbox, 按照指引进行安装.
 - 如果安装成功, 就会出现**kitematic(Alpha)**和**Docker Quickstart**两个图标, 前者是图形化管理方式, 后者是命令行管理方式

# 坑
 - 系统的虚拟化问题, 这个网络上有很多文章描述, 这里就不再赘述.
 - 启动Docker Quickstart 报出找不到bash.exe, 解决方式多种多样, 只要找到bash.exe即可
 - 再起启动, 报出检测到没有 Boot2Docker，会进行下载, 但是下载过程异常使得下载失败，最后启动失败
  > 解决方式为:
    如果存在下载失败的临时文件，要将其删除。（我的机器上的路径是C:\Users\zheng\.docker\machine\cache\boot2docker.iso.tmp24517390）
    自己用其他工具去下载对应的 boot2docker.iso 文件（下载链接：https://github.com/boot2docker/boot2docker/releases/download/v17.05.0-ce/boot2docker.iso）在网站栏输入一下网址即可下载
    然后放置到对应的目录（我的是：C:\Users\zheng\.docker\machine\cache\boot2docker.iso）就可以了。

 - 其他坑链接: [windows下玩docker踩过的坑][http://www.jianshu.com/p/d4a5c5e144c6]

 # 参考文章
 [win7启动Docker 报错怎么办？启动Docker 报错的解决方法](http://www.winwin7.com/JC/Win7JC-2511.html)