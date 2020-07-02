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


