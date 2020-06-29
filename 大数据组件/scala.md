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