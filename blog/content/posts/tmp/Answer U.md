## python装饰器@语法介绍及作用和用途？

### 介绍
装饰器@语法是python的一种特殊的语法，它可以让我们更方便地修改函数、方法（以及可能的类）的行为，而不需要显式地修改它们。它支持更可读的装饰器模式（DecoratorPattern）的应用，也支持其他的用途。

### 用途和作用

#### 装饰器的作用是在不改变原函数定义和调用方式的情况下，给原函数增加一些额外的功能。这些功能通常和原函数的逻辑无关，而是和一些通用的需求有关，例如日志记录、性能测试、缓存、权限验证等。

#### 装饰器的用途是实现一种高阶函数（higher-order function），即一个接受函数作为参数并返回一个新函数的函数。这样可以让我们把一些通用的功能封装在装饰器函数中，然后通过@语法来应用到不同的原函数上，实现代码的复用和解耦。

#### python中有一些内置的装饰器，例如@property、@classmethod、@staticmethod等，它们可以让我们更方便地定义类属性、类方法和静态方法。

#### python中也有一些第三方库提供了一些常用的装饰器，例如flask中的@app.route()、functools中的@lru_cache()等，它们可以让我们更方便地实现一些web开发、缓存等功能。

#### python中也可以自定义装饰器，只需要定义一个接受函数作为参数并返回一个新函数的函数，并在新函数中调用原函数并添加一些额外的功能即可


```python
from time import time

# 这是一个装饰器函数
def timer(func):
    def wrapper():
        start = time()
        func()
        end = time()
        print(f"{func.__name__}运行时间:{end - start}")
    return wrapper

# 使用装饰器  
@timer
def foo():
    print("foo函数运行中...")
    for i in range(10000):
        i ** 2

foo()
```

## 简述join() 和 split() 方法？

#### 介绍

###### 1. join()方法
- 作用:用指定的字符串连接序列中的元素,并返回连接后的新字符串。
- 语法:'分隔符'.join(sequence)
- sequence可以是列表,元组,集合,字典等

###### 2. split()方法:
- 作用:用指定的分隔符对字符串进行切片,并返回切片后的子字符串组成的列表。
- 语法:字符串.split(分隔符)

#### 示例
```python
result = []
temp = ""
twitter = ["0_7_15_0_14_7_21", "-13_11_15", "-13_11_20", "-14_27"]
# x是字符串
for x in twitter:
    # 不能使用twitter[x], 报错list indices must be integers or slices not str
    numbers = x.split('_')
    for y in numbers:
        temp += chr(90 + int(y))
        result.append(temp)
        
```

## python变量前＆和*符号的作用？

#### &符号用于传递变量的引用。
在funcA(argA, &argB)的调用中,argB必须是一个变量,&表示传入argB的引用而不是值。在funcA内部,对argB的修改将影响到外部的argB变量。

``` python
def funcA(a, &b):
    print(a, b) 
    b = 20 # 修改b的值

b = 10
funcA(1, b) 
print(b) # 输出20
```


#### *符号用于接收不定长的参数。
在funcB(argA, *argB)的调用中,*argB允许你传入0个或多个参数,这些参数被组装成一个tuple赋值给参数argB。

```python
def funcB(a, *b):
    print(a, b)

funcB(1) # 1 ()  
funcB(1, 2, 3) # 1 (2, 3)
```
所以简单来说:
- &用于传递变量引用
- *用于接收不定长参数


## c++中类名后的*、&和~符号的作用？

#### * 代表指针,表示一个指向该类型的指针变量。
```cpp  
// observer是一个指向observer类类型的指针。
observer* observer   
```  
  
#### & 代表引用,表示一个对该类型的引用。  
```cpp  
// enity是一个对Entity类型的常引用。  
// const关键字的作用是使该引用enity成为一个常量引用,无法通过它来修改所引用的对象。  
// 具体来说:
// - Entity& 表示这是一个对Entity对象的引用。
// - const修饰这个引用,使得它成为一个常引用,无法通过它来修改所引用的对象。
// 这样做的好处是:
// 1. 避免通过引用意外修改对象,增强程序健壮性。
// 2. 可以让编译器进行优化,如果函数不修改引用指向的对象,那编译器可以进行一些性能优化。
// 3. 对于类成员,可以在声明时使其成为常引用,防止修改。
// 所以,const的作用是使引用及指针无法修改所指向的对象,起到一个保护对象不被修改的作用
const Entity& enity  
``` 

#### ~ 代表析构函数,它会在类的对象销毁时执行。
```cpp    
// 定义一个virtual析构可以让子类正确执行析构。
// 所以在C++中,正确使用指针、引用和析构函数对类的设计非常重要。
// 指针用于传递对象地址,提高效率;引用用于避免复制,节省空间;析构用于释放资源。
virtual ~Entity() { 
    // 析构函数代码
}  
```

## python中闭包和垃圾回收机制
#### 闭包
Python中一般通过嵌套函数实现闭包,内部函数可以访问外部函数的变量:
```python
def outer():
    x = 1
    def inner():
        print(x)
        
    return inner 

closure = outer()
closure() # 输出1

# inner函数封闭保存了outer函数的x,所以inner就是一个闭包。
# 我们也可以通过lambda表达式创建闭包:
y = 2 
closure = lambda: print(y)
```


#### 垃圾回收
Python与PHP都是使用引用计数进行自动垃圾回收。当一个对象的引用计数降为0时,会被自动回收。
```python
import sys

# Python还可以通过gc模块手动触发垃圾回收。
a = Object()
print(sys.getrefcount(a)) # 2

b = a 
print(sys.getrefcount(a)) # 3 

del b
print(sys.getrefcount(a)) # 2

del a
# a自动被回收
```

## 面向对象变成常见继承关系和关键字作用？详细讲解面向切面编程

#### 面向对象
##### 公有继承,子类继承父类所有公开属性和方法:
```python
class Parent:
    def public_method(self):
        pass

class Child(Parent):
    # 可以访问public_method
    pass
```
##### 保护继承,子类只继承保护(单下划线)和公有属性/方法:
```python
class Parent:
    def _protected_method(self):
        pass

class Child(Parent):
    # 只可以访问public_method
```

##### 面向切面编程
Python中可以通过装饰器实现AOP:
```python
from functools import wraps

# 这里log装饰器在不修改add函数的情况下,为其添加了日志打印功能。
def log(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Call {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@log  
def add(x, y):
    return x + y

add(2, 3)

# 打印:
# Call add
# 5
```

## python连接存储数据DB的主流方式介绍。

##### 使用数据库接口模块:Python内置了MySQLdb、psycopg2等模块,可以很方便的连接MySQL、PostgreSQL等数据库。
```python
import MySQLdb

conn = MySQLdb.connect(host='localhost', user='root', passwd='123456', db='test')
cur = conn.cursor()
cur.execute('select * from tb_user')
```

##### 使用ORM框架:如SqlAlchemy、Django ORM等,可以实现对象关系映射,通过面向对象的方式操作数据库,不需要写SQL语句。
``` python
from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = 'user'

    id = Column(Integer, primary_key=True)
    name = Column(String)
```

##### 使用NoSQL数据库:如MongoDB、Redis等,用Key-Value或者文档形式存储,通过官方或第三方提供的驱动连接。
``` python
import pymongo

client = pymongo.MongoClient(host='localhost', port=27017)
db = client['testdb']
col = db['user']
``` 

## 社经新闻
1. 财政部公布2023年上半年财政收支情况，其中社会保障和就业支出21791亿元，同比增长7.9%，主要用于养老、医疗、失业、工伤等保险基金转移支付，以及实施就业扶贫、稳岗返还等政策。
2. 国家统计局发布6月份国民经济运行情况，其中全国居民消费价格同比上涨1.1%，环比下降0.4%；工业生产者出厂价格同比上涨8.8%，环比上涨0.3%；工业生产者购进价格同比上涨12.5%，环比上涨0.8%。
3. 国家统计局发布6月份国民经济运行情况，其中全国城镇调查失业率为5.0%，同比下降0.7个百分点，环比下降0.1个百分点；全国城镇登记失业率为3.5%，持平于上年同期。
4. 国家统计局发布6月份国民经济运行情况，其中全国房地产开发投资71154亿元，同比增长15%，增速比1-5月份回落1.4个百分点；商品房销售面积8亿平方米，同比增长27.7%，增速比1-5月份回落2个百分点；商品房销售额88555亿元，同比增长36.3%，增速比1-5月份回落2个百分点。
5. 中国在酒泉卫星发射中心用长征二号丁运载火箭，成功将高分十三号卫星送入预定轨道。高分十三号卫星是一颗高分辨率对地观测卫星，主要用于国土普查、城市规划、土地确权、路网设计、农作物估产和防灾减灾等领域。
6. 中国科学家在量子计算领域取得重大突破，实现了光量子计算机的超越经典计算能力。该光量子计算机采用了光学波导芯片，能够实现66个光量子比特的可控操作，完成了一项复杂的线性代数问题，耗时约200秒，而最快的经典超级计算机需要2.5亿年才能完成。这是继去年中国科学家实现超导量子计算机的超越经典计算能力后，又一次在量子计算领域的重大突破。
7. 中国人民银行发布6月份全国金融统计数据报告，其中全国人民币贷款增加22100亿元，同比多增111亿元；社会融资规模增加35700亿元，同比多增11100亿元；人民币广义货币（M2）余额231.95万亿元，同比增长8.6%，增速比上月末低0.3个百分点。
8. 国家外汇管理局发布6月份全国外汇储备规模为32167亿美元，较5月份增加230亿美元，增幅为0.72%。国家外汇管理局表示，6月份外汇储备规模变动主要受到汇率和资产价格变化等因素的影响。
9. 中国人民银行发布6月份全国银行间同业拆借市场运行情况，其中银行间同业拆借加权平均利率为2.14%，较上月下降0.01个百分点；银行间质押式回购加权平均利率为2.17%，较上月下降0.01个百分点；银行间协议式回购加权平均利率为2.16%，较上月下降0.02个百分点。



