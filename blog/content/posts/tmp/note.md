# 新测试服(test03)木马中毒报告

## 问题描述

新测试服（test03）被黑客利用PHP-FPM服务端口（9000）进行远程代码执行攻击，导致服务器被植入木马程序和蠕虫病毒。该问题影响了服务器的正常运行和数据安全，造成了严重的损失。

## 问题分析

经过排查分析，发现该问题主要有以下两个原因：

系统漏洞：新测试服开放了9000端口，而该端口是PHP-FPM服务使用的端口，黑客通过连接该端口直接调用了PHP-FPM服务，并执行了恶意代码。其他环境没有受到影响，是因为其他环境没有开放该端口。
文件感染：新测试服复制过来的旧测试服文件已经被感染了木马程序和蠕虫病毒，在新测试服上运行时就会自动释放并传播。

## 处理过程
为了解决该问题，采取了以下措施：

#### 基础运维监控
1. 重新清理权限账号， 重新梳理文件权限
2. 关闭不紧要端口，仅开放443， 22020等必须端口
3. 开启防火墙，梳理防火墙权限

#### 文件传输与杀毒
1. 重置磁盘后，分批次传输文件，并在每次传输后使用clamav比对最新病毒库进行扫描。
2. 将传出文件权限控制在docker容器内，并将docker容器权限局限在项目文件夹内，形成即使docker容器中毒也不会影响宿主机的隔离机制

## 处理结果
经过以上处理后，达到了以下效果：

1. 导入测试服文件所有项目文件，过滤杀毒后，未发现异常
2. 经过一晚上IO网络监控和进程监控，没有再次发现病毒告警及异常进程和流量

## 预防措施
为了避免类似问题再次发生，提出以下建议：

1. 将安全管理的方式方法在生产和预发环境
2. 不定期变更鉴权密码，隐私key
3. 更新系统和软件补丁，修复已知的漏洞

# 容器列表

### pxb7-php-worker-1
 - supervisord
 - 配置地址/data/docker/php-worker/supervisord.d/
 
###  pxb7-openresty-1
- openresty
- nginx conf地址/data/docker/openresty/site/



# 前期测试成本预算
### 阿里云服务器
项目	规格	数量	单价（元/年）	总价（元/年）
ESC服务器	4c8g	20	1200	24000
Redis主从	4c8g	1	1440	1440
MySQL主从	8c16g	1	3600	3600
总计	-	-	-	29040



# excel VBA 处理表格数据demo
```
  Sub ConvertTextToOrderedList()
      Dim cell As Range
      Dim text As String
      Dim result As String
      Dim i As Integer
      Dim arr() As String
      
      ' 遍历E列中的每个单元格
      For Each cell In Range("E1:E" & Cells(Rows.Count, "E").End(xlUp).Row)
          ' 将单元格的文本内容赋值给text变量
          text = cell.Value
          If Not IsEmpty(text) Then
              ' 检查text变量中是否有+号
              If InStr(text, "+") > 0 Then
                  ' 如果有+号，则将text变量按照+号（左右有空格）进行拆分，并赋值给arr数组
                  arr = Split(text, " + ")
                  ' 将arr数组中的第一个元素添加到result字符串中，并去除两端的空格
                  result = "1. " & Trim(arr(0))
                  ' 从第二个元素开始遍历arr数组中的每个元素
                  For i = 1 To UBound(arr)
                      ' 将arr数组中的每个元素添加到result字符串中，并去除两端的空格，并用换行符分隔
                      result = result & vbLf & (i + 1) & ". " & Trim(arr(i))
                  Next i
              Else
                  ' 如果没有+号，则直接将text变量赋值给result字符串，并去除两端的空格
                  result = Trim(text)
              End If
              ' 在F列中输出结果
              cell.Offset(0, 1).Value = result
          End If
      Next cell
  End Sub

```