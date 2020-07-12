## Java泛型

### 泛型类

泛型类有一个重要的应用就是容器类，比如列表或者Map等，你不知道会将什么类型放到容器里面。

```java
public class Container<K, V> {
    K key;
    V value;

    public Container(K k, V v) {
        this.key = k;
        this.value = v;
    }
}

class Main{
    public static void main(String[] args) {
        Container<String, String> m1 = new Container<>("name", "zzx");
        Container<String, Integer> m2 = new Container<>("age", 10);
    }
}
```

### 泛型接口

生成器是泛型的一个很好的例子

```java
import java.util.Random;

interface Generator<T>{
    T next();
}

class FruitGenerator implements Generator<String>{
    private final String[] fruit = new String[]{"apple", "banana", "pear"};

    @Override
    public String next() {
        Random r = new Random();
        return fruit[r.nextInt(3)];
    }
}

public class Main{
    public static void main(String[] args) {
        FruitGenerator f = new FruitGenerator();
        System.out.println(f.next());
    }
}
```

### 泛型方法

一个基本的原则是：无论何时，只要你能做到，你就应该尽量使用泛型方法。

```java
public class Main {

    public static <T> void out(T t) {
        System.out.println(t);
    }

    public static void main(String[] args) {
        out("findingsea");
        out(123);
        out(11.11);
        out(true);
    }
}
```

泛型方法写在返回值的前面。

## Java容器

Java容易分为Collection和Map两大类，各自有很多子类

![](chart/容器.jpg)

### 常用集合操作

1）`Hashset`

```java
add()
remove()
contains()
clear()
size()

// 1. 增强for循环
HashSet<String> set = new HashSet<String>();
for(String s: set){};  
// 2. 迭代器
Iterator<String> it = set.iterator();
while(it.hasNext()){
	String s = set.next()
}
```

2）`ArrayList`

`ArrayList`是一个其容量能够动态增长的动态数组。

```java
add()
remove(i)  // 删除第i个元素
size()  // 包含的元素数量
Contains() // 调用IndexOf、Contains等方法是执行的简单的循环来查找元素

// 遍历多了一种通过下标遍历
```

3）`Hashmap`

```java
put(key, value)  // 添加值
containsKey()
containsValue()
get(key)

// 迭代
Iterator<Map.Entry<Integer, Integer>> iterator = hashMap.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<Integer, Integer> entry = iterator.next();
            Integer key = entry.getKey();
            Integer value = entry.getValue();
            System.out.print(key + "--->" + value);
            System.out.println();
        }
Iterator<Integer> iterator2 = hashMap.keySet().iterator();
		while (iterator2.hasNext()) {
			Integer key = iterator2.next();
			Integer value = hashMap.get(key);
			System.out.print(key + "---" + value);
			System.out.println();
		}
```

4）`Array`

```java
// 两种声明方式
int arr[];  
int[] arr;

// 初始化方式
int arr[] new int[]{1, 2, 3, 4, 5};
int[] arr = {1, 2, 3, 4, 5};

// for或者foreach循环

// 数组长度
arr.length;
```



## Java注解



## Java反射机制

一个类有：成员变量、方法、构造方法、包等等信息，利用反射技术可以对一个类进行解剖，把个个组成部分映射成一个个对象。

类Class的实例表示正在运行的Java应用程序中的类和接口。 枚举是一种类，注释是一种接口，每个数组还属于一个被反射为Class对象的类，该类对象由类型和维数相同的所有数组共享。 原始Java类型（布尔，字节，字符，short，int，long，float和double）以及关键字void也表示为Class对象。该类没有公共构造函数。 相反，Java虚拟机会在加载类时以及通过在类加载器中调用defineClass方法来自动构造Class对象。

java的反射机制就是增加程序的灵活性，避免将程序写死到代码里， 例如： 实例化一个 person()对象， 不使用反射， new person(); 如果想变成 实例化 其他类， 那么必须修改源代码，并重新编译。 使用反射：class.forName("person").newInstance()；而且这个类描述可以写到配置文件中，如 *.xml, 这样如果想实例化其他类，只要修改配置文件的"类描述"就可以了，不需要重新修改代码并编译。

### 获取Class对象的三种方法

Student类

```java
class Student {
    String name;
    int age;
    String sex;

    public Student(String name, int age, String sex) {
        this.name = name;
        this.age = age;
        this.sex = sex;
        System.out.println(this.name);
    }

    public Student(String name) {
        this.name = name;
        System.out.println(this.name);
    }

    public void learn(String project) {
        System.out.println("learning: " + project);
    }
}
```

1）Object:getClass()

2）任何数据类型都有"静态"class属性

3）通过Class类的静态方法forName(String className)

```java
Student s = new Student();
// 第一种
Class stuClass = s.getClass();
// 第二种
Class stuClass = Student.class;
// 第三种
Class stuClass = Class.forName("Student");  // 第三种要加try catch
```

### 通过反射获取构造方法并使用

```java
Constructor[] conArray = stuClass.getConstructors();  // 所有公有构造方法
Constructor[] conArray = stuClass.getDeclaredConstructors();  // 所有构造方法
Constructor con = stuClass.getConstructor();  // 公有无参构造方法
Constructor con = stuClass.getDeclaredConstructor(String.class)  // 获取参数是一个String类型的构造方法
    
Object obj = con.newInstance("James");  // 这里会调用Student类中对应的构造函数
Student s = (Student) obj;  // 可以转成Student对象
```

### 通过反射获取成员变量并调用

```java
Field[] fieldArray = stuClass.getFields();  // 获取所有公有字段
Field[] fieldArray = stuClass.getDeclaredFields();  // 获取所有的字段

Field f = stuClass.getDeclaredField("name");  // 获取字段name并调用
Object obj = stuClass.getConstructor(String.class).newInstance("James");
f.set(obj, "Duncan");  // 为Student对象中的name属性赋值
```

### 通过反射获取成员方法并调用

```java
Method[] methodArray = stuClass.getMethods();  // 获取公有方法
Method[] methodArray = stuClass.getDeclaredMethods();  // 获取所有的方法

Method m = stuClass.getDeclaredMethod("learn", String.class);  // 获取learn方法
Object obj = stuClass.getConstructor(String.class).newInstance("James");
m.setAccessible(true);  //解除私有限定
m.invoke(obj, "中文")  // 调用learn方法，一个是调用对象，另一个是实参。当m时静态方法时，obj可以用null
```

## Java内部类

### 实例内部类

```java
class Outter{
    public String attr = "outter";
    class Inner{
        public String attr = "inner";
        public void play(){
            System.out.println(this.attr);
            System.out.println(Outter.this.attr);  // 调用外部类成员同名变量
        }
    }
    public void callInnerPlay(){
        Inner inner = new Inner();
        inner.play();
    }
}

public class Demo {
    public static void main(String[] args) {
        Outter outter = new Outter();
        Outter.Inner inner = new Outter().new Inner();  // 创建内部类
        inner.play();
        outter.callInnerPlay();  // 在外部类中调用内部类
    }
}
```

### 静态内部类

```java
public class Test {
    public static void main(String[] args)  {
        Outter.Inner inner = new Outter.Inner();
    }
}
 
class Outter {
    public Outter() {
         
    }
    static class Inner {
        public Inner() {
        }
    }
}
```

### 局部内部类

方法内部类定义在外部类的方法中，局部内部类和成员内部类基本一致，只是它们的作用域不同，方法内部类只能在该方法中被使用，出了该方法就会失效。 对于这个类的使用主要是应用与解决比较复杂的问题，想创建一个类来辅助我们的解决方案，到那时又不希望这个类是公共可用的，所以就产生了局部内部类。

```java
class People {
    public People() {
    }
}

class Man {
    public Man() {
    }

    public People getWoman() {
        class Woman extends People {   //局部内部类
            int age = 0;  // 只有函数内能访问局部内部类
            public void getAge(){
                System.out.println(this.age);
            }
        }
        return new Woman();
    }
}

public class Demo {
    public static void main(String[] args) {
        Man man = new Man();
        People woman = man.getWoman();
    }
}
```



### 匿名内部类

匿名内部类不能定义任何静态成员、方法和类，只能创建匿名内部类的一个实例。一个匿名内部类一定是在new的后面，用其隐含实现一个接口或实现一个类。

#### 未使用匿名内部类

```java
abstract class Person {
    public abstract void eat();
}
 
class Child extends Person {
    public void eat() {
        System.out.println("eat something");
    }
}
 
public class Demo {
    public static void main(String[] args) {
        Person p = new Child();
        p.eat();
    }
}
```



#### 在接口上使用匿名内部类

```java
interface Person {
    public void eat();
}
 
public class Demo {
    public static void main(String[] args) {
        Person p = new Person() {
            @Override
            public void eat() {
                System.out.println("eat something");
            }
        };
        p.eat();
    }
}
```

#### 在抽象方法上使用匿名内部类

```java
abstract class Person {
    public abstract void eat();
}
 
public class Demo {
    public static void main(String[] args) {
        Person p = new Person() {
            @Override
            public void eat() {
                System.out.println("eat something");
            }
        };
        p.eat();
    }
}
```

#### lambda表达式

```java
// 1. 不需要参数,返回值为 5  
() -> 5  
  
// 2. 接收一个参数(数字类型),返回其2倍的值  
x -> 2 * x  
  
// 3. 接受2个参数(数字),并返回他们的差值  
(x, y) -> x – y  
  
// 4. 接收2个int型整数,返回他们的和  
(int x, int y) -> x + y  
  
// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)  
(String s) -> System.out.print(s)
```

```java
// 匿名内部类使用lambda表达式，这种又叫做函数式接口，在接口Person上可以加上@FunctionalInterface(不加也没有报错)，函数式接口(Functional Interface)就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口。函数式接口可以被隐式转换为 lambda 表达式。
interface Person {
    public void eat();
}
 
public class Demo {
    public static void main(String[] args) {
        Person p = () -> System.out.println("eating something");
        p.eat();
    }
}
```

## 通配符和边界

* <? extends T>：是指 **“上界通配符（Upper Bounds Wildcards）”**

* <? super T>：是指 **“下界通配符（Lower Bounds Wildcards）”**

### 为什么要用通配符和边界？

使用泛型的过程中，经常出现一种很别扭的情况。比如按照题主的例子，我们有Fruit类，和它的派生类Apple类。

```java
class Fruit {}
class Apple extends Fruit {}
```

然后有一个最简单的容器：Plate类。盘子里可以放一个泛型的“东西”。我们可以对这个东西做最简单的“放”和“取”的动作：set( )和get( )方法。

```java
class Plate<T>{
    private T item;
    public Plate(T t){item=t;}
    public void set(T t){item=t;}
    public T get(){return item;}
}

public class Demo {
    public static void main(String[] args) {
        Plate<Fruit> plate = new Plate<Apple>(new Apple());  // 定义一个装水果的盘子，编译报错
    }
}
```

#### 上界通配符

```java
Plate<? extends Fruit>
Plate<? extends Fruit> p=new Plate<Apple>(new Apple());  // ok了
```

#### 下界通配符

```java
Plate<？ super Fruit>
```

上界通配符包含了本身和子类，下届通配符包含了本身和父类。

## Java流Stream

这种风格将要处理的元素集合看作一种流， 流在管道中传输， 并且可以在管道的节点上进行处理， 比如筛选， 排序，聚合等。

元素流在管道中经过中间操作（intermediate operation）的处理，最后由最终操作(terminal operation)得到前面处理的结果。

### 生成流

* **stream()** − 为集合创建串行流。
* **parallelStream()** − 为集合创建并行流。

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd", "", "jkl");
List<String> collect = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
```

### forEach

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

### map

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
// 获取对应的平方数
List<Integer> squaresList = numbers.stream().map( i -> i*i).distinct().collect(Collectors.toList());
```

### filter

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量
long count = strings.stream().filter(string -> string.isEmpty()).count();
```

### limit

```java
Random random = new Random();
random.ints().limit(10).forEach(System.out::println);
```

### sorted

```java
Random random = new Random();
random.ints().limit(10).sorted().forEach(System.out::println);
```

### parallel

```java
List<String> strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
// 获取空字符串的数量
int count = strings.parallelStream().filter(string -> string.isEmpty()).count();
```

### Collectors

```java
List<String>strings = Arrays.asList("abc", "", "bc", "efg", "abcd","", "jkl");
List<String> filtered = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.toList());
 
System.out.println("筛选列表: " + filtered);
String mergedString = strings.stream().filter(string -> !string.isEmpty()).collect(Collectors.joining(", "));
System.out.println("合并字符串: " + mergedString);
```

### 统计

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
 
IntSummaryStatistics stats = numbers.stream().mapToInt((x) -> x).summaryStatistics();
 
System.out.println("列表中最大的数 : " + stats.getMax());
System.out.println("列表中最小的数 : " + stats.getMin());
System.out.println("所有数之和 : " + stats.getSum());
System.out.println("平均数 : " + stats.getAverage());
```

## Java8函数接口

## Java默认方法

```java
interface Vehicle {
    // 默认方法，继承该接口可以不用override print就能直接调用
    default void print() {
        System.out.println("我是一辆车!");
    }

    // 默认静态方法，可以直接Vehicle.blowHorn调用
    static void blowHorn() {
        System.out.println("按喇叭!!!");
    }
}

interface FourWheeler{
    default void print(){
        System.out.println("我是四轮车");
    }
}

class Car implements Vehicle, FourWheeler{
    @Override
    public void print() {
        Vehicle.super.print();  // 继承的多个接口有两个以上的默认方法必须重写，在重写中可以调用某一个默认方法
    }
}

public class MainApp {
    public static void main(String[] args) {
        Vehicle vehicle = new Car();
        vehicle.print();
    }
}
```

