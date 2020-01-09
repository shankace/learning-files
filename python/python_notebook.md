1.zip与zip(\*)的问题
```
x=["a","1"]
y=["b","2"]
z = list(zip(x,y))
print (list(zip(x,y)))
print (list(zip(*z)))


>>>[('a', 'b'), ('1', '2')]

>>>[('a', '1'), ('b', '2')]

```
zip与zip(\*)相当于压缩和加压的关系
