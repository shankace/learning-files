### case类的特点

case类会生成许多模板代码

1）会生成一个apply方法，可以不用new关键字来创建实例

2）构造函数的参数默认是val，自动生成访问方法

3）会生成一个默认toString方法

4）默认生成unapply方法，在模式匹配时很好用

5）生成equals和hashCode方法

6）生成copy方法

### 用Case类生成模板代码

模板代码包括了访问和修改方法，apply，unapply，toString，equals，hashCode等方法。

* 生成apply方法，可以不用new关键字创新实例。

  ```scala
  case class Person(name:String, relation:String)
  val emily = Person("Emily", "niece")
  ```

* 构造函数默认参数是val。

* 生成默认的toString方法。

* 生成一个unapply方法，在模式匹配时很好用。

  ```scala
  emily match{
      case Person(n, r) => println(n, r)
  }
  ```

* 生成equals和hashCode方法。

  ```
  val hannah = Person("Hannah", "niece")
  emily == hannah  //false
  ```

* 生成copy方法。

  ```scala
  val fred = emily.copy(name="fred")  //复制时，里面的变量可以改值
  ```

  

### 方法

#### 控制方法作用域

Scala可见行控制符

| 修饰符           | 描述                                   |
| ---------------- | -------------------------------------- |
| private[this]    | 对当前实例可见                         |
| private          | 对当前类多有实例可见                   |
| protected        | 对当前类及其子类的实例可见             |
| private[model]   | 对com.acme.coolapp.model包下所有类可见 |
| private[coolapp] | 对com.acme.coolapp包下所有类可见       |
| private[acme]    | 对com.acme包下所有类可见               |
| (无修饰符)       | 公开方法                               |

注：protected级别含义在Scala和Java中有所不同。在Java中，protected方法可以在同一个包中其它类访问，在Scala中是不可以的。下面代码无法编译，因为Jungle类不能访问Animal类的breathe方法，即使他们是在同一个包：

```scala
package world{
	class Animal{
		protected def breathe{}
	}
	class Jungle{
        val a = new Animal
        a.breathe  // error:this line won't compile
	}
}
```

#### 控制调用方法所属的特质

```scala
trait Human{
	def hello = "the Human trait"
}
trait Mother extends Human{
	override hello = "Mother"
}
trait Father extends Human{
	override hello = "Father"
}
class Child extends Human with Mother with Father{
	def printSuper = super.hello
	def printMother = super[Mother].hello
	def printFather = super[Father].hello
	def printHuman = super[Human].hello
}
```

#### 链式编码风格

* 如果类会被扩展，把this.type作为链式调用风格方法的返回值类型。
* 如果类不会被扩展，则把this从链式调用方法中返回出来。

```scala
class Person{
    var fname:String = ""
    var lname:String = ""
    def setFirstName(firstName:String):this.type = {
        this.fname = firstName
        this
    }
    def setLastName(lastName:String):this.type = {
        this.lname = lastName
        this
    }
}

class Person{
    var fname:String = ""
    var lname:String = ""
    def setFirstName(firstName:String) = {
        this.fname = firstName
        this
    }
    def setLastName(lastName:String) = {
        this.lname = lastName
        this
    }
    override def toString = {
        this.fname + this.lname
    }
}

object Main extends App{
    val p = Person
    println(p.setFirstName("z").setLastName("zx"))
}
```

### 限制特质使用范围

#### 通过继承来限制特质使用范围

```scala
class Animal

class Cat extends Animal {
  println("创建Cat实例")
}

trait Walk extends Cat

class SmallCat extends Cat with Walk {
  println("创建SmallCat实例")
}

object Demo extends App {
  val cat = new Cat with Walk
  val smallCat = new SmallCat
}
```

特质Walk继承了Cat类，则只有Cat类和Cat类的子类可以使用Walk特质。

#### 限定特质只能使用指定子类

和上面等价

```scala
class Animal

class Cat extends Animal {
  println("创建Cat实例")
}

trait Walk {
  this: Cat =>
}

class SmallCat extends Cat with Walk {
  println("创建SmallCat实例")
}

object Demo extends App {
  val cat = new Cat with Walk
  val smallCat = new SmallCat
}
```

#### 限定特质被添加必须实现特定方法

```scala
trait Walk{
  this: {def walk()} =>
}

class Animal extends Walk{
  def walk(): Unit ={
    println("walking")
  }
  def swim(): Unit = {
    println("swimming")
  }
}

object Demo extends App {
  val cat = new Animal
  cat.walk()
  cat.swim()
}
```

继承Walk的特质必须实现walk方法

#### 为实例对象添加特质

构造对象时混入日志

```scala
trait Debug{
  def log(): Unit ={
    println("打印日志")
  }
}

class Child

object Demo extends App {
  val child = new Child with Debug
  child.log()
}
```

### 函数式编程

##### 匿名函数

```scala
val x = List.range(1, 10)
val even = x.filter((i: Int) => i % 2 == 0)  // 声明Int可以去掉

// 等价
val even = x.filter(_ % 2 == 0)  // 允许使用"_"通配符替换变量名

// 如果一个函数只有一条语句，并且只有一个参数，那么参数不需要特别指定
x.foreach(println)
```

##### 将函数作为变量

**=>**可以看做是一个转换器

```scala
val double = (i: Int) => {i * 2}
val list = List.range(1, 5)

list.map(double)
```

###### 像匿名函数一样使用方法

```scala
def modMethod(i: Int) = i % 2 == 0
val list = List.range(1, 10)
list.filter(modMethod)
```

###### 给已存在的方法或者函数赋给函数变量

```scala
val c = scala.math.cos _  // 单个变量
val p = scala.math.pow(_, _) // 多个变量
val p = scala.math.pow _  // 等价上面那个
```

##### 定义简单的函数作为参数的方法

1）定义方法，包括期望接受的函数参数的签名

2）定义满足这个签名的一个或多个函数

3）将函数作为参数传递给方法

```scala
def executeFunction(callback:() => Unit){
    callback()
}
val sayHello = () => {println("Hello")}
executeFunction(sayHello)

// 两种签名等价
executeFunction(f:String => Int)
executeFunction(f:(String) => Int)
```

###### 传入函数外的其他参数

```scala
def executeXTimes(callback:() => Unit, numTimes: Int){
	for(i <- 1 to numTimes) callback()
}
```

##### 使用部分应用函数

创建一个函数并且预加载一些值

```scala
val sum = (a: Int, b: Int, c: Int) => a + b +c
val f = sum(1, 2, _: Int)
val f = sum(1, _: Int, _: Int)
```

##### 创建返回函数的函数

```scala
def saySomething(prefix: String) = (s: String) => {
    prefix + " " + s
}
```

##### 偏函数

偏函数(Partial Function)，是一个数学概念它不是"函数"的一种, 它跟函数是平行的概念。
 Scala中的Partia Function是一个Trait，其的类型为PartialFunction[A,B]，其中接收一个类型为A的参数，返回一个类型为B的结果。

```scala
val pf: PartialFunction[Int, String] = {
    case 1 => "One"
    case 2 => "Two"
    case _ => "Other"
}  // 使用case可以快速定义偏函数，{}+case

// 偏函数内部有一些方法，比如isDefinedAt、OrElse、 andThen、applyOrElse
pf.isDefinedAt(1)  // 判断偏函数传入的参数是否在偏函数的范围

// 重写isDefinedAt方法
val divide = new PartialFunction[Int, Int] {
    def apply(x: Int) = 42 / x
    def isDefinedAt(x: Int) = x != 0
}

def fun: PartialFunction[Int, String] = {
    case 1 => "one"
}
```



### 集合

#### 基本概念

1）谓词

一个方法、函数或者匿名函数接受一个参数或者多个参数返回一个Boolean值。

```scala
def isEven(i: Int) = if (i % 2 == 0) true else false
```



2）匿名函数

```scala
(i: Int) => i % 2 == 0
```



3）隐式循环

```scala
val list = List.range(1, 10)
val events = list.filter(_ % 2 == 0)
```

#### 集合层级结构

![image-20200716095201045](chart/集合层级.png)

#### 不可变序列

![不可变集合](chart/不可变集合.png)

#### 可变序列1

![可变集合](chart/可变集合.png)

#### 可变序列2

![image-20200716103649896](chart/可变集合2.png)

#### Map

![image-20200716103833724](chart/map.png)

#### Set

![image-20200716103939087](chart/Set.png)