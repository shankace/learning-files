### 复杂数据类型

| 类型   | 定义方法 | 构造方法                                          |
| ------ | -------- | ------------------------------------------------- |
| ARRAY  | array<int><br />array<struct<a:int, b:string>> | array(1, 2, 3)<br />array(array(1, 2), array(3, 4)) |
| MAP    | map<string, string><br />map<smallint, array<string>> | map(“k1”, “v1”, “k2”, “v2”)<br />map(1S, array(‘a’, ‘b’), 2S, array(‘x’, ‘y’)) |
| STRUCT | struct<x:int, y:int><br />struct<field1:bigint, field2:array<int>, field3:map<int, int>> | named_struct(‘x’, 1, ‘y’, 2)<br />named_struct(‘field1’, 100L, ‘field2’, array(1, 2), ‘field3’, map(1, 100, 2, 200)) |

### **ROW_NUMBER() OVER函数的基本用法**

row_number() OVER (PARTITION BY COL1 ORDERBY COL2)表示根据COL1分组，在分组内部根据COL2排序，而此函数计算的值就表示每组内部排序后的顺序编号（该编号在组内是连续并且唯一的)。

```sql
SELECT *
	,Row_Number() OVER (partition by deptid ORDER BY salary desc) rank 
FROM employee
```
### **窗口函数**
1） 专用窗口函数，包括后面要讲到的rank, dense_rank, row_number等专用窗口函数。

2） 聚合函数，如sum. avg, count, max, min等

```sql
select *,
   rank() over (partition by 班级
                 order by 成绩 desc) as ranking
from 班级表
```

因为窗口函数是对where或者group by子句处理后的结果进行操作，所以窗口函数原则上只能写在select子句中。

#### hive执行顺序

hive语句和mysql都可以通过 explain+代码 查看执行计划，这样就可以查看执行顺序 

from … where … select … group by … having … order by …