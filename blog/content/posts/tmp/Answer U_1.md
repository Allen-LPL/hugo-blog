# 一、角度与弧度的定义和关系

## 代码
``` Python
#draw the circle
import math
import turtle

x = 0   # 圆心坐标x  
y = 0   # 圆心坐标y
r = 100  # 圆的半径

turtle.penup()
turtle.goto(x,y-r) 
turtle.pendown()

for i in range(0, 365, 5):      
    a = math.radians(i)   
    turtle.setpos(x + r * math.cos(a), y + r * math.sin(a))
```

## 执行结果
![角度与弧度](vx_images/222782796836497_1.png)


# 二、python3中set对象是什么，set.intersection()是什么以及方法如何使用，如何使用python *运算符号来展开参数列表？

## 代码
``` Python
#Python 中的 set 是一种无序不重复的集合。set.intersection() 是计算两个集合的交集。
# 创建两个集合
s1 = {1, 2, 3}
s2 = {2, 3, 4}

# 使用 intersection() 计算交集
print(s1.intersection(s2))
# 输出:{2, 3}

s3 = s1.intersection(s2)
print(s3) 
# 输出:{2, 3}




# *操作符用来展开参数列表,可以将列表或元组转为函数的参数。
def print_params(x, y, z):
    print(x, y, z)

params = [1, 2, 3]

# 普通调用    
print_params(params[0], params[1], params[2])
# 1 2 3

# 使用 * 运算符展开参数    
print_params(*params)  # 在函数调用时,*params 相当于向函数传入三个参数 1,2,3。 
# 1 2 3
```


# 三、tuple()方法
``` Python
#tuple() 函数是用来将列表、元组或者字符串转换为元组。

# 从列表转换为元组
list1 = [1, 2, 3] 
tuple1 = tuple(list1)
print(tuple1) # 输出 (1, 2, 3)

# 从元组转换为元组 
tuple2 = (4, 5, 6)
tuple3 = tuple(tuple2)
print(tuple3) # 输出 (4, 5, 6)

# 从字符串转换为元组
str1 = "abc"
tuple4 = tuple(str1)
print(tuple4) # 输出 ('a', 'b', 'c')

# 可以将 range 对象转换为元组:
range1 = range(3)
tuple5 = tuple(range1) 
print(tuple5) # 输出 (0, 1, 2)

```

## 代码示例讲解：
``` Python

导入相关库
import sys, os, random, argparse  
from PIL import Image  
import imghdr
import numpy as np


# 这段代码实现了一个抛光马赛克。其功能是:
# - 给定目标图像和一系列输入图像
# - 将目标图像划分为相应大小的块
# - 从输入图像中搜索最接近每块颜色的图像
# - 用这些颜色匹配的输入图像拼接形成马赛克
# 主要功能:
# - getAverageRGB() 计算图像的平均RGB值
# - splitImage() 将图像划分为指定大小的块
# - getImages() 读取输入文件夹中的图像
# - getBestMatchIndex() 根据RGB值查找最佳匹配
# - createImageGrid() 创建块图像网格
# - createPhotomosaic() 整合上述功能实现抛光马赛克的创建
# - main() 解析命令行参数并调用 createPhotomosaic() 函数
# 总的来说,该脚本实现了以下功能:
# - 读取目标图像和输入图像集合
# - 将目标图像分块
# - 按照RGB值寻找最佳匹配输入图像块
# - 拼接这些匹配块形成马赛克
# - 输出抛光马赛克图像
# 主要使用了 Pillow 库中的 Image 对象处理图像,argparse 解析命令行参数。
# numpy 用来计算图像的平均RGB值。
# 整体流程:
# 1. 解析输入参数(目标图像、输入图像文件夹、分块大小、输出文件名)
# 2. 读取输入图像集合
# 3. 分割目标图像
# 4. 计算每个目标图像块和输入图像块的RGB平均值
# 5. 根据RGB值查找最佳匹配的输入图像块
# 6. 用匹配块组成网格图像
# 7. 输出结果图像 (edited)

#定义一个函数获取图像的平均 RGB 值
def getAverageRGBOld(image):
  计算图像像素数量 
  npixels = image.size[0]*image.size[1]
  获取颜色 [(cnt1, (r1, g1, b1)), ...]
  cols = image.getcolors(npixels)  
  获取 [(c1*r1, c1*g1, c1*g2),...]
  sumRGB = [(x[0]*x[1][0], x[0]*x[1][1], x[0]*x[1][2]) for x in cols]     
  计算 (sum(ci*ri)/np, sum(ci*gi)/np, sum(ci*bi)/np) 
  avg = tuple([int(sum(x)/npixels) for x in zip(*sumRGB)])  
  返回平均 RGB 值    
  return avg

#定义一个函数将图像分割为指定大小的小块
def splitImage(image, size):
   ...

#定义一个函数读取文件夹内的图像    
def getImages(imageDir):
   ...

#定义一个函数获取目录下图像文件的名称
def getImageFilenames(imageDir):    
   ...
  
#定义一个函数获取最佳匹配的输入图像块    
def getBestMatchIndex(input_avg, avgs):    
   ...

#定义一个函数创建图像块网格    
def createImageGrid(images, dims):
   ...
      
#定义主要函数创建抛光马赛克   
def createPhotomosaic(target_image, input_images, grid_size,
                      reuse_images=True):
   ...
      
#定义主函数解析命令行参数并调用其他函数   
def main():   
   # 解析参数
   ... 
   ###### 输入 ######    
   # 目标图像     
   ...     
   # 输入图像    
   ...   
   ...
   # 调用创建抛光马赛克函数
   mosaic_image = createPhotomosaic(...)

   # 输出结果图像  
   ...      

#主程序入口    
if __name__ == '__main__':
  main()
```

### np.average(im.reshape(w*h, d), axis=0)讲解
```Python
np.average(im.reshape(w*h, d), axis=0) 这行代码的作用是计算图像的平均 RGB 值。
具体来说:
- im 是图像的 numpy 数组表示
- w,h 是图像的宽高
- d 是图像的通道数,一般为 3(RGB)
- im.reshape(w*h, d) 把图像展平为 (w*h, d) 大小的数组,也就是一列一列的像素点
- np.average() 函数计算数组平均值
- axis=0 指定沿着第一轴(列)计算平均值
综上,这行代码的效果相当于:
- 把图像展平为 w*h行,3列(RGB)的数组
- 计算各列(R、G、B通道)的平均值
- 得到 (R平均值,G平均值,B平均值)
也就是图像的平均 RGB 值。
所以执行结果会是一个长度为 3 的元组,表示图像的红、绿、蓝三个颜色通道的平均值。

tuple(np.average(im.reshape(w*h, d), axis=0))的执行结果：

```
![执行结果](vx_images/406705706625589_1.png)


# 四、numpy库数组常用方法介绍？
## 代码
```Python
import numpy as np

N=100
np.array([])
np.zeros(N*N).reshape(N,N)
np.random.choice([1,0],N*N,p=[0.2,0.8]).reshape(N,N)
angles = 2*math.pi*np.random.rand(N)
vel = np.array(list(zip(np.sin(angles),np.cos(angles))))
x=vel.reshape(2*N)[::2]
y=vel.reshape(2*N)[1::2]

# 这段代码分别执行了以下操作:
# 1. import numpy as np:导入 numpy 库
# 2. N=100:定义 N 等于100
# 3. np.array([]):创建一个 empty 数组
# 4. np.zeros(N*N).reshape(N,N):创建一个 100x100 的 0 矩阵
# 5. np.random.choice([1,0],N*N,p=[0.2, 0.8]).reshape(N,N):创建一个 100x100 的 0/1 矩阵,0 和 1 的概率分别是 0.2 和 0.8
# 6. angles = 2*math.pi*np.random.rand(N):生成 N 个随机角度
# 7. vel = np.array(list(zip(np.sin(angles),np.cos(angles)))):根据角度计算速度向量
# 8. x=vel.reshape(2*N)[::2]:从速度向量取出 x 速度分量
# 9. y=vel.reshape(2*N)[1::2]:从速度向量取出 y 速度分量
# 整体效果是:
# - 生成一个大小为 100x100 的 0 矩阵
# - 生成一个 0/1 马塞克矩阵
# - 生成 100 个随机角度
# - 根据角度计算 100 个速度向量
# - 分离出 x 和 y 速度分量
# 所以最终的结果为:
# - 一个 0 矩阵
# - 一个 0/1 马塞克矩阵
# - 一个包含 100 个随机角度的数组
# - 两个包含 100 个 x 和 y 速度分量的数组
# 总的来说,这段代码利用 numpy 功能,生成了几个随机或零数组,主要演示了 numpy 的 shape 操作。


>>> import numpy as np
>>> from scipy.spatial.distance import pdist, squareform
>>> squareform(pdist())

# scipy.spatial.distance: scipy 库提供了一系列用于科学计算的 Python 模块。spatial 子模块提供了空间数据结构和算法。distance 子模块提供了用于计算距离和相似性矩阵的函数。
# 具体介绍:
# - numpy:
# numpy 是用于执行 large,multi-dimensional array and matrix operations 的 Python 库。它提供一个高性能的多维数组对象 ndarray,并且可以用于线性代数、傅立叶变换等方面。
# - scipy.spatial.distance:
# pdist() 函数计算矩阵中两两不同观测值之间的距离。
# squareform() 函数则将距离矩阵转换为距离向量。

>>> from scipy.spatial.distance import pdist, squareform
>>> X = [[0, 1],
         [1, 1],
         [2, 0],
         [10, 10]]
>>> Y = pdist(X)
>>> Y
array([  1.        ,   1.41421356,   2.        ,  10.04030396])
>>> Z = squareform(Y)
>>> Z
array([[ 0.        ,  1.        ,  2.        , 10.04030396],
       [ 1.        ,  0.        ,  1.41421356, 10.19803842],
       [ 2.        ,  1.41421356,  0.        ,  9.21954446],
       [10.04030396, 10.19803842,  9.21954446,  0.        ]])

# pdist() 计算了数据点之间的距离,squareform() 将距离转换为距离矩阵。
# 总的来说,主要是导入`numpy`用于数值计算,以及`scipy.spatial.distance`中的`pdist()`和`squareform()`用于计算和转换距离。

```

