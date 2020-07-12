## Spring框架中的AOP

Spring 框架的一个关键组件是**面向方面的编程**(AOP)框架。面向方面的编程需要把程序逻辑分解成不同的部分称为所谓的关注点。跨一个应用程序的多个点的功能被称为**横切关注点**，这些横切关注点在概念上独立于应用程序的业务逻辑。有各种各样的常见的很好的方面的例子，如日志记录、审计、声明式事务、安全性和缓存等。在 OOP 中，关键单元模块度是类，而在 AOP 中单元模块度是方面。

### AOP 术语

| 项            | 描述                                                         |
| ------------- | ------------------------------------------------------------ |
| Aspect        | 一个模块具有一组提供横切需求的 APIs。例如，一个日志模块为了记录日志将被 AOP 方面调用。应用程序可以拥有任意数量的方面，这取决于需求。 |
| Join point    | 在你的应用程序中它代表一个点，你可以在插件 AOP 方面。你也能说，它是在实际的应用程序中，其中一个操作将使用 Spring AOP 框架。 |
| Advice        | 这是实际行动之前或之后执行的方法。这是在程序执行期间通过 Spring AOP 框架实际被调用的代码。 |
| Pointcut      | 这是一组一个或多个连接点，通知应该被执行。你可以使用表达式或模式指定切入点正如我们将在 AOP 的例子中看到的。 |
| Introduction  | 引用允许你添加新方法或属性到现有的类中。                     |
| Target object | 被一个或者多个方面所通知的对象，这个对象永远是一个被代理对象。也称为被通知对象。 |
| Weaving       | Weaving 把方面连接到其它的应用程序类型或者对象上，并创建一个被通知的对象。这些可以在编译时，类加载时和运行时完成。 |

### 通知的类型

| 通知           | 描述                                                         |
| -------------- | ------------------------------------------------------------ |
| 前置通知       | 在一个方法执行之前，执行通知。                               |
| 后置通知       | 在一个方法执行之后，不考虑其结果，执行通知。                 |
| 返回后通知     | 在一个方法执行之后，只有在方法成功完成时，才能执行通知。     |
| 抛出异常后通知 | 在一个方法执行之后，只有在方法退出抛出异常时，才能执行通知。 |
| 环绕通知       | 在建议方法调用之前和之后，执行通知。                         |

- **@Before**: 在切点之前，织入相关代码；
- **@After**: 在切点之后，织入相关代码;
- **@AfterReturning**: 在切点返回内容后，织入相关代码，一般用于对返回值做些加工处理的场景；
- **@AfterThrowing**: 用来处理当织入的代码抛出异常后的逻辑处理;
- **@Around**: 环绕，可以在切入点前后织入代码，并且可以自由的控制何时执行切点；

### 例子

1）切入点为注解，标注了注解的方法会执行该方面

#### 声明一个注解

```java
@Retention(RetentionPolicy.RUNTIME)  
@Target({ElementType.METHOD})  // 作用在方法上
public @interface WebLog {
}
```



#### 声明一个Aspect类

```java
@Aspect  // 声明一个方面，这是面向切面编程的基本元素，和面向对象编程中的class一样
public class WebLogAspect {

    @Pointcut("@annotation(com.chrollo.WebLog)")  // 声明一个切入点，这里的切入点是一个注解
    public void webLog(){
    }

    @Before("webLog()")  // 在@WebLog注解的函数前执行
    public void doBefore(JoinPoint jp){
        System.out.println("执行doBefore");
    }
    
    @After("webLog()")
    public void doAfter() {
        // 接口结束后换行，方便分割查看
        	System.out.println("执行doAfter");
        }
    
    @Around("webLog()")
    public Object doAround(ProceedingJoinPoint proceedingJoinPoint) {
        long startTime = System.currentTimeMillis();
        Object result = proceedingJoinPoint.proceed();
        // 打印出参
        long endTime = System.currentTimeMillis();
        System.out.println("执行所耗的时间"+(endTime-startTime).toString())
        return result;
    }
```



#### Student类

```java
package com.chrollo;

public class Student {
    private Integer age;
    private String name;

    public void setAge(Integer age) {
        this.age = age;
    }

    public Integer getAge() {
        System.out.println("Age : " + age);
        return age;
    }

    public void setName(String name) {
        this.name = name;
    }

    @WebLog  // 因为在Aspect中的切入点为WebLog注解，因此在标记该注解的函数执行Aspect中的方法，也可以将一个类中的所有函数都设置为切入点，就不需要标注，该类下的每个函数都会执行Aspect中的方法。@Pointcut("execution(* com.chrollo.*.*(..))") 切入点为com.chrollo包下所有类中的所有方法。
    public String getName() {
        System.out.println("Name : " + name);
        return name;
    }

    public void printThrowException() {
        System.out.println("Exception raised");
//        throw new IllegalArgumentException();
    }
}

```

#### Main文件

```java
package com.chrollo;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
public class MainApp {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext("Beans.xml");
        Student student = (Student) context.getBean("student");
        student.getName();
        student.getAge();
    }
}

// 执行doBefore
// Name : Zara
// Age : 11
```



#### Beans.xml文件

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
    http://www.springframework.org/schema/aop
    http://www.springframework.org/schema/aop/spring-aop-3.0.xsd ">

    <aop:aspectj-autoproxy/>

    <!-- Definition for student bean -->
    <bean id="student" class="com.chrollo.Student">
        <property name="name"  value="Zara" />
        <property name="age"  value="11"/>
    </bean>

    <!-- Definition for webLogAspect aspect -->
    <bean id="webLogAspect" class="com.chrollo.WebLogAspect"/>

</beans>
```

