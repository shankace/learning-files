## 创建版本库
### 创建git仓库
```
$ mkdir learngit
$ cd learngit
$ pwd
/Users/michael/learngit
$ git init
Initialized empty Git repository in /Users/michael/learngit/.git/
```

### 把一个文件放到Git仓库
```
git add readme.txt  
git commit -m "wrote a readme file"  # 提交说明

# commit一次可以提交多个文件
git add file1.txt
git add file2.txt file3.txt
git commit -m "add 3 files."
```
## git基本操作
### 版本回退
版本控制系统肯定有某个命令可以告诉我们历史记录，在Git中，我们用git log命令查看
```
git log  # 命令显示从最近到最远的提交日志, 如果嫌输出信息太多，看得眼花缭乱的，可以试试加上--pretty=oneline参数
git log --pretty=oneline
```
首先，Git必须知道当前版本是哪个版本，在Git中，用HEAD表示当前版本，也就是最新的提交1094adb...（注意我的提交ID和你的肯定不一样），上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100。
```
$ git reset --hard HEAD^  # hard暂时不用管
```
最新的那个版本append GPL已经看不到了！好比你从21世纪坐时光穿梭机来到了19世纪，想再回去已经回不去了，肿么办？

办法其实还是有的，只要上面的命令行窗口还没有被关掉，你就可以顺着往上找啊找啊，找到那个append GPL的commit id是1094adb...，于是就可以指定回到未来的某个版本：
```
$ git reset --hard 1094a
```
版本号没必要写全，前几位就可以了，Git会自动去找。当然也不能只写前一两位，因为Git可能会找到多个版本号，就无法确定是哪一个了。此外Git提供了一个命令git reflog用来记录你的每一次命令

### 工作区和暂存区
![git结构图](./git图.jpg)
工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库。Git的版本库里存了很多东西，其中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支master，以及指向master的一个指针叫HEAD。  
第一步是用git add把文件添加进去，实际上就是把文件修改添加到暂存区；第二步是用git commit提交更改，实际上就是把暂存区的所有内容提交到当前分支。  
因为我们创建Git版本库时，Git自动为我们创建了唯一一个master分支，所以，现在，git commit就是往master分支上提交更改。
#### 查看当前状态
```
$ git status
```

### 管理修改
只要进行add操作的内容能被commit上去。用git diff HEAD -- readme.txt命令可以查看工作区和版本库里面最新版本的区别：
```
$ git diff HEAD -- readme.txt
```
### 撤销修改
当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令git checkout -- file。
```
$ git checkout -- file
```
当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD <file>，就回到了场景1，第二步按场景1操作
```
$ git reset HEAD readme.txt
```
### 删除文件
一般情况下，你通常直接在文件管理器中把没用的文件删了，或者用rm命令删了：
```
$ rm test.txt
```
* 现在你有两个选择，一是确实要从版本库中删除该文件，那就用命令git rm删掉，并且git commit：
```
$ git rm test.txt
$ git commit -m "remove test.txt"
```
* 另一种情况是删错了，因为版本库里还有呢，所以可以很轻松地把误删的文件恢复到最新版本：
```
$ git checkout -- test.txt
```
git checkout其实是用版本库里的版本替换工作区的版本，无论工作区是修改还是删除，都可以“一键还原”。
## 远程仓库
```
ssh-keygen -t rsa -C "youremail@example.com"
```
生成秘钥和github绑定
### 添加远程仓库
### 从远程仓库clone
1. 从远程拉一个文件夹到本地
```
git clone https://github.com/shankace/learning-files.git
```
会在当前目录创建learning-files文件夹。  
2. 提交文件
* 提交所有文件
```
git add .
```
* 提交单个文件
```
git add <filename>
git commit -m "message"
git push origin master
```
