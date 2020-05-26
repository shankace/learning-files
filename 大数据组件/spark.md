# 配置idea
## 配置scala
1. 在File-->Settings-->Plugins搜索安装scala插件，可以离线安装
2. 配置jdk
3. 在File-->Project Structure  
Global Libraries添加scala-sdk-2.11.12  
Libraries添加scala-sdk-2.11.12
## maven环境
1. 建立maven环境、
2. Settings中搜索Maven，在Maven home directory目录的settings.xml中添加阿里源
3. 在pom.xml中添加dependency以来，注意对应版本
4. 如果maven插件没有自动下载依赖，右键pom.xml文件，选择maven-->Reimport

# spark
## Quick start
```
package main.scala
import org.apache.spark.sql.SparkSession

object test {
    def main(args: Array[String]): Unit = {
        val file = "E:\\项目\\testmaven\\src\\main\\resources\\README.md"
        val spark = SparkSession.builder.appName("Simple Application").getOrCreate()
        val logData = spark.read.textFile(file)
        val countA = logData.filter(line => line.contains("a")).count()
        println(s"包含a的行有${countA}个.")
        spark.close()
    }
}
```
报错：A master URL must be set in your configuration，需要在配置文件中的VM options选项中设置-Dspark.master=local。
## RDDs，Accumulators，Broadcasts Vars
### RDDS
#### Parallelized Collections
Parallelized collections are created by calling SparkContext’s parallelize method on an existing collection in your driver program.
```
val conf = new SparkConf().setAppName(appName).setMaster(master)
val sc = new SparkContext(conf)
val data = Array(1, 2, 3, 4, 5)
val distData = sc.parallelize(data)
```
注意：有个重要的参数，partitions可以人工指定，sc.parallelize(data, 10)，指定将dataset分为几个部分。
#### External Datasets
Spark can create distributed datasets from any storage source supported by Hadoop, including your local file system, HDFS, Cassandra, HBase, Amazon S3, etc.
```
val distFile = sc.textFile("data.txt")
```
Some notes on reading files with Spark:
* All of Spark’s file-based input methods, including textFile, support running on directories, compressed files, and wildcards as well. For example, you can use textFile("/my/directory"), textFile("/my/directory/*.txt"), and textFile("/my/directory/*.gz").
* The textFile method also takes an optional second argument for controlling the number of partitions of the file. By default, Spark creates one partition for each block of the file (blocks being 128MB by default in HDFS), but you can also ask for a higher number of partitions by passing a larger value. Note that you cannot have fewer partitions than blocks.
#### RDD Operations
RDDs support two types of operations: $transformations$, which create a new dataset from an existing one, and $actions$, which return a value to the driver program after running a computation on the dataset.  

All transformations in Spark are lazy, in that they do not compute their results right away. Instead, they just remember the transformations applied to some base dataset (e.g. a file). The transformations are only computed when an action requires a result to be returned to the driver program.   

By default, each transformed RDD may be recomputed each time you run an action on it. However, you may also persist an RDD in memory using the persist (or cache) method, in which case Spark will keep the elements around on the cluster for much faster access the next time you query it. There is also support for persisting RDDs on disk, or replicated across multiple nodes.
#### Basics
```
val lines = sc.textFile("data.txt")
val lineLengths = lines.map(x => x.length)
val totalLenght = lineLengths.reduce((a, b)=>a+b)
```
If we also wanted to use lineLengths again later, we could add:
```
lineLengths.persist()
```
before the reduce, which would cause lineLengths to be saved in memory after the first time it is computed.
## Spark中的序列化机制
在写Spark的应用时，尝尝会碰到序列化的问题。例如，在Driver端的程序中创建了一个对象，而在各个Executor中会用到这个对象 —— 由于Driver端代码与Executor端的代码运行在不同的JVM中，甚至在不同的节点上，因此必然要有相应的序列化机制来支撑数据实例在不同的JVM或者节点之间的传输。

## RDD的宽窄依赖

![img](./chart/d宽窄依赖.jpg)

窄依赖，表示父亲 RDDs 的一个分区最多被子 RDDs 一个分区所依赖。宽依赖，表示父亲 RDDs 的一个分区可以被子 RDDs 的多个子分区所依赖。比如，map 操作是一个窄依赖，join 操作是一个宽依赖操作（除非父亲 RDDs 已经被 hash 分区过）。

每一个方框表示一个 RDD，带有颜色的矩形表示分区。以下两个原因使的这种区别很有用，第一，窄依赖可以使得在集群中一个机器节点的执行流计算所有父亲的分区数据，比如，我们可以将每一个元素应用了 map 操作后紧接着应用 filter 操作，与此相反，宽依赖需要父亲 RDDs 的所有分区数据准备好并且利用类似于 MapReduce 的操作将数据在不同的节点之间进行重新洗牌和网络传输。第二，窄依赖从一个失败节点中恢复是非常高效的，因为只需要重新计算相对应的父亲的分区数据就可以，而且这个重新计算是在不同的节点进行并行重计算的，与此相反，在一个含有宽依赖的血缘关系 RDDs 图中，一个节点的失败可能导致一些分区数据的丢失，但是我们需要重新计算父 RDD 的所有分区的数据。

- HDFS files：抽样的输入 RDDs 是 HDFS 中的文件。对于这些 RDDs，partitions 返回文件中每一个数据块对应的一个分区信息（数据块的位置信息存储在 Partition 对象中），preferredLocations 返回每一个数据块所在的机器节点信息，最后 iterator 负责数据块的读取操作。
- map：对任意的 RDDs 调用 map 操作将会返回一个 MappedRDD 对象。这个对象含有和其父亲 RDDs 相同的分区信息和数据存储节点信息，但是在 iterator 中对父亲的所有输出数据记录应用传给 map 的函数。
- union：对两个 RDDs 调用 union 操作将会返回一个新的 RDD，这个 RDD 的分区数是他所有父亲 RDDs 的所有分区数的总数。每一个子分区通过相对应的窄依赖的父亲分区计算得到。
- sample：sampling 和 mapping 类似，除了 sample RDD 中为每一个分区存储了一个随机数，作为从父亲分区数据中抽样的种子。
- join：对两个 RDDs 进行 join 操作，可能导致两个窄依赖（如果两个 RDDs 都是事先经过相同的 hash/range 分区器进行分区），或者导致两个宽依赖，或者一个窄依赖一个宽依赖（一个父亲 RDD 经过分区而另一个没有分区）。在上面所有的恶场景中，join 之后的输出 RDD 会有一个 partitioner（从父亲 RDD 中继承过来的或者是一个默认的 hash partitioner）
## job调度器
当一个用户对某个 RDD 调用了 action 操作（比如 count 或者 save）的时候调度器会检查这个 RDD 的血缘关系图，然后根据这个血缘关系图构建一个含有 stages 的有向无环图（DAG），最后按照步骤执行这个 DAG 中的 stages，如图 5 的说明。每一个 stage 包含了尽可能多的带有窄依赖的 transformations 操作。这个 stage 的划分是根据需要 shuffle 操作的宽依赖或者任何可以切断对父亲 RDD 计算的某个操作（因为这些父亲 RDD 的分区已经计算过了）。然后调度器可以调度启动 tasks 来执行没有父亲 stage 的 stage（或者父亲 stage 已经计算好了的 stage），一直到计算完我们的最后的目标 RDD 。

![img](./chart/rdd_stages.jpg)

spark job stage 的例子。实线的方框表示 RDDs ，带有颜色的方形表示分区，黑色的是表示这个分区的数据存储在内存中，对 RDD G 调用 action 操作，我们根据宽依赖生成很多 stages，且将窄依赖的 transformations 操作放在 stage 中。在这个场景中，stage 1 的输出结果已经在内存中，所以我们开始运行 stage 2，然后是 stage 3。

我们调度器在分配 tasks 的时候是采用延迟调度来达到数据本地性的目的（说白了，就是数据在哪里，计算就在哪里）。如果某个分区的数据在某个节点上的内存中，那么将这个分区的计算发送到这个机器节点中。如果某个 RDD 为它的某个分区提供了这个数据存储的位置节点，则将这个分区的计算发送到这个节点上。