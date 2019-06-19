### 0

```bash
#!/usr/bin/env bash

echo "hello world!"
```

```bash
# 查看当前正在使用shell解释器
ps | grep $$

# 查看当前shell解释器对应的文件绝对路径
type bash

# 查看当前bash的版本号
bash --version

# shell 内置帮助
help type
help help
```

### 1
```bash
#!/usr/bin/env bash
PRICE_PER_APPLE=5
echo "The price of an Apple today is: \$HK $PRICE_PER_APPLE"

MyFirstLetters=ABC
echo "The first 10 letters in the alphabet are: ${MyFirstLetters}DEFGHIJ"

greeting='Hello        world!'
echo $greeting" now with spaces: $greeting"     # 此处实际上实现了一个字符串 拼接/连接 操作

# 其他程序的输出结果直接赋值给shell变量
FILELIST=`ls`
FileWithTimeStamp=$(/bin/date +%Y-%m-%d).txt

echo $FILELIST
echo $FileWithTimeStamp
```

### 2

```bash
#!/usr/bin/env bash
# 代码填空，使用最终输出3个包含correct的语句
BIRTHDATE='Jan 1 2000'   # 填入一个字符串
Presents=10    # 填入一个整数
BIRTHDAY=$(/bin/date -d "$BIRTHDAY" +%A)    # 使用命令替换方法赋值


# 测试代码 - 勿修改

if [ "$BIRTHDATE" == "Jan 1 2000" ] ; then
    echo "BIRTHDATE is correct, it is $BIRTHDATE"
else
    echo "BIRTHDATE is incorrect - please retry"
fi
if [ $Presents == 10 ] ; then
    echo "correct! I have received $Presents presents"
else
    echo "Presents is incorrect - please retry"
fi
if [ "$BIRTHDAY" == "Saturday" ] ; then
    echo "correct! I was born on a $BIRTHDAY"
else
    echo "BIRTHDAY is incorrect - please retry"
```

### 3 调试

```bash
# 调试模式运行，逐行执行“命令”并打印“命令”接受的输入参数值
$ bash -x <script.sh>

# 代码片段临时开启调试模式
set -x          # activate debugging from here
w
set +x          # stop debugging from here

# 写文件
echo -e "$msg"

# 如果打印变量内容包含「不可打印字符」
# msg="hello world\x01\x02"
echo -n -e "$msg" | xxd -p
```

### 4 传参

`bash 4.sh apple 5 banana 8 "Fruit Basket" 15`

```bash
# $0 指代脚本文件本身
# $1 指代命令行上的第1个参数
# $2 指代命令行上的第2个参数，以此类推其他参数的脚本内引用方法
# $@ 指代命令行上的所有参数（参数数组）
# $# 指代命令行上的参数个数（参数数组大小）

#!/usr/bin/env bash

echo $3 # --> results with: banana

BIG=$5

echo "A $BIG costs just $6"

# 输出所有参数
echo "$@"

# 以下代码输出命令行参数的总数
echo $#
```

### 5 数组

```bash
#!/usr/bin/env bash

# 查看当前 Bash 的 declare 支持的参数
# help declare

# 声明一个「索引」数组
declare -a indexed_arr

# 声明一个「关联」数组
declare -A associative_arr

# Bash 数组赋值方法如下
# 「索引」数组可以跳过数组声明直接赋值的同时即完成了数组初始化
my_array=(apple banana "Fruit Basket" orange)

associative_arr['hello']='world'
associative_arr['well']='done'

# bash支持“稀疏”数组：即数组元素不必连续存在，个别索引位置上可以有未初始化的元素
new_array[2]=apricot

# 数组元素的个数通过 ${#arrayname[@]} 获得
echo ${#my_array[@]}

# 随机读取数组中的元素，必须有{}
echo ${my_array[2]}

# 遍历数组的方法
## 「索引」数组
for ele in "${my_array[@]}";do
    echo "$ele"
done

## 「关联」数组
for key in "${!associative_arr[@]}";do
    echo "$key ${associative_arr[$key]}"
done
```

### 6 数组代码填空

```bash
#!/usr/bin/env bash
NAMES=( John Eric Jessica )

# 代码填空，使得以下代码避免输出failed关键字
NUMBERS=(1 2 3 4 5 6 7 8 9 10)  # 构造包含1到10整数的数组
STRINGS=(hello world)  # 构造分别包含hello和world字符串的数组
NumberOfNames=${#NAMES[@]} # 请使用动态计算数组元素个数的方法
second_name=${NAMES[1]}  # 读取NAMES数组的第2个元素值进行赋值

# 测试代码 - 勿修改

T_NUMBERS=$(seq 1 10)
T_STRINGS=(hello world)

# Test Case 1
i=0
for n in ${T_NUMBERS[@]};do
  if [[ ${n} -ne ${NUMBERS[${i}]} ]];then
    echo "failed in NUMBERS test"
  fi
  i=$((i+1))
done

# Test Case 2
i=0
for n in ${T_STRINGS[@]};do
  if [[ "${n}" != "${STRINGS[${i}]}" ]];then
    echo "failed in STRINGS test"
  fi
  i=$((i+1))
done

# Test Case 3
if [[ $NumberOfNames -ne ${#NAMES[@]} ]];then
    echo "failed in NumberOfNames test"
fi

# Test Case 4
if [[ "${NAMES[1]}" != "${second_name}" ]];then
  echo "failed in Array Element Access test"
fi
```

### 7 算术运算

```bash
#!/usr/bin/env bash

# 使用 $((expression)) 算术运算符表达式，注意这种方式只支持 整数运算
A=3
B=$((100 * A + 5)) # 305
echo $B

# 计算 4 * arctangent(1) ，计算结果保留 10 位有效数字
# -l 表示使用标准数学库
pi=$(echo "scale=10; 4*a(1)" | bc -l)
echo $pi

# 计算 4 * arctangent(1) ，计算结果保留 1000 位有效数字
# 禁止输出结果因超长而自动折行
pi=$(BC_LINE_LENGTH=0 bc -l <<< "scale=1000; 4*a(1)")
echo $pi
```

### 8 字符串操作

```bash
#!/usr/bin/env bash

# 获得字符串长度值
STRING="this is a string"
echo ${#STRING}            # 16

# 注意非拉丁语系字符串长度计算
M_STRING="中文"
export LANG=C.UTF-8
echo ${#M_STRING}            # 2
export LANG=C
echo ${#M_STRING}            # 6

# 字符串截取子串
STRING="this is a string"
POS=1
LEN=3
echo ${STRING:$POS:$LEN}   # his
echo ${STRING:1}           # $STRING contents without leading character
echo ${STRING:12}          # ring

# 注意非拉丁语系字符串截取
export LANG=C
echo -n "${M_STRING:0:1}" | xxd -p # e4
export LANG=C.UTF-8
echo -n "${M_STRING:0:1}" | xxd -p # e4b8ad

# 字符串查找并替换第一次匹配到的子串
STRING="to be or not to be"
echo ${STRING[@]/be/eat}   # to eat or not to be
```

### 9 字符串替换

```bash
#!/usr/bin/env bash

# 字符串查找并替换所有匹配到的子串
STRING="to be or not to be"
echo ${STRING[@]//be/eat}  # to eat or not to eat

# 字符串查找并删除（替换为空）所有匹配到的子串
STRING="to be or not to be"
echo ${STRING[@]// not/}        # to be or to be

# 字符串查找并替换匹配到行首的子串
STRING="to be or not to be"
echo ${STRING[@]/#to be/eat now}    # eat now or not to be

# 字符串查找并替换匹配到行尾的子串
STRING="to be or not to be"
echo ${STRING[@]/%be/eat}        # to be or not to eat

# 字符串查找并使用子命令输出结果替换匹配项
STRING="to be or not to be"
echo ${STRING[@]/%be/be on $(date +%Y-%m-%d)}
```

### 10 条件判断

```bash
#!/usr/bin/env bash
if [[ 0 ]];then printf "%d" 0;fi
if [[ 1 ]];then printf "%d" 1;fi
if [[ true ]];then printf "%d" 2;fi
if [[ false ]];then printf "%d" 3;fi
if [[ '' ]];then printf "%d" 4;fi
if [[ '   ' ]];then printf "%d" 5;fi
if [[ 'true' ]];then printf "%d" 6;fi
if [[ 'false' ]];then printf "%d" 7;fi
if [[ '$mamashuozhegebianliangbukenengdingyiguo' ]];then printf "%d" 8;fi
if [[ "$mamashuozhegebianliangbukenengdingyiguo" ]];then printf "%d" 9;fi
```

### 11 选择条件分支
```bash
#!/usr/bin/env bash
mycase=1
case $mycase in
    1) echo "You selected bash";;
    2) echo "You selected perl";;
    3) echo "You selected phyton";;
    4) echo "You selected c++";;
    5) exit
esac
```

### 12 for 循环

```bash
#!/usr/bin/env bash
# loop on array member
NAMES=(Joe Jenny Sara Tony)
for N in ${NAMES[@]} ; do
  echo "My name is $N"
done

# loop on command output results
for f in $(ps -eo command) ; do
  echo "$f"
done

# loop on command output results 健壮性改进版本
set -e
for f in $(ps -eo command 2>/dev/null) ; do
  [[ -e "$f" ]] || continue 
  ls "$f"
done

# 下面是改进前的「脆弱」版本，对比执行找不同
set -e
for f in $(ps -eo command) ; do
  ls "$f"
done
```

### 13 while 循环

```bash
#!/usr/bin/env bash
COUNT=4
while [ $COUNT -gt 0 ]; do
  echo "Value of count is: $COUNT"
  COUNT=$(($COUNT - 1))
done

COUNT=4
while [ : ]; do
  echo "Value of count is: $COUNT"
  COUNT=$(($COUNT - 1))
  if [[ $COUNT -eq 0 ]];then
     break
  fi
done
```

### 14 until循环

条件为假时，执行循环体内代码。为真时，跳过循环体代码段

```bash
#!/usr/bin/env bash
COUNT=1
until [ $COUNT -gt 5 ]; do
  echo "Value of count is: $COUNT"
  COUNT=$(($COUNT + 1))
done
```

### 15 break和continue

```bash
#!/usr/bin/env bash

# Prints out 0,1,2,3,4

COUNT=0
while [ $COUNT -ge 0 ]; do
  echo "Value of COUNT is: $COUNT"
  COUNT=$((COUNT+1))
  if [ $COUNT -ge 5 ] ; then
    break
  fi
done

# Prints out only odd numbers - 1,3,5,7,9
COUNT=0
while [ $COUNT -lt 10 ]; do
  COUNT=$((COUNT+1))
  # Check if COUNT is even
  if [ $(($COUNT % 2)) = 0 ] ; then
    continue
  fi
  echo $COUNT
done
```

### FAIL-FAST：避免错误蔓延

```bash
# 脚本只要发生错误，就终止执行
# 不能终止管道命令中执行出错的语句
# 只要最后一个子命令不失败，管道命令总是会执行成功
set -e

# 关闭 -e 选项
set +e

# 让脚本在更严格的条件下执行
set -eo pipefail
```

SHELL脚本静态分析工具 - shellcheck

### 16 函数

function关键字是可选的，主要区别在于可移植性

```bash
# 基本定义方法，可移植性最好
function_name () compound-command [ redirections ]

# 现代主流shell解释权均支持的语法，可以避免alias机制污染函数名
function function_name [()] compound-command [ redirections ]
```

```bash
#!/usr/bin/env bash
function function_B {
  echo "Function B."
}
function function_A {
  echo "$1"
}
function adder {
  echo "$(($1 + $2))"
}

# 调用函数，传参
function_A "Function A."     # Function A.
function_B                   # Function B.
adder 12 56                  # 68
```

### gcd
** 求最大公约数 **
- 通过命令行参数读取2个整数，对不符合参数调用规范（使用小数、字符、少于2个参数等）的脚本执行要给出明确的错误提示信息，并退出代码执行

求两个正整数的最大公因子

```bash
#!usr/bin/env bash

if [ $# -lt 2 ]
then
  echo "Please input two integer"
  exit -1
elif [[ "$1" == *[!0-9]* || "$2" == *[!0-9]* ]]
then
  echo "Not number or not intrger"
  exit -1
elif [[ "$1" -lt 1 || "$2" -lt 1 ]]
then
  echo "Number should greater than 1"
  exit -1
fi

if [ "$1" -gt "$2" ]
then
  a=$1
  b=$2
else
  a=$2
  b=$1
fi

while [ "$b" -ne 0 ]; do
  remainder=$(( "$a" % "$b" ))
  a=$b
  b=$remainder
done

echo "GCD of $1 and $2 is $a"
exit 0
```

### 17 特殊变量、文件读写

特殊变量

```bash
$0 # 当前脚本的文件名
$n # 脚本或函数的第N个传入参数
$# # 脚本或函数传入参数的个数
$@ # 脚本或函数传入的所有参数（数组形式）
$* # 脚本或函数传入的所有参数（字符串形式）
$? # 最近一条命令或函数的退出状态码
$$ # 当前shell解释器的进程编号，对脚本来说就是当前脚本解释器的进程编号
$! # 最近一个进入后台执行的进程的进程编号
```

文件读写

```bash
#!/usr/bin/env bash

# 利用I/O重定向机制

# 清空一个文件（文件大小变为0）
> file
# 用一段文本内容覆盖一个文件
echo "some string" > file
# 在文件尾部追加内容
echo "some string" >> file

# 读取文件的第一行并将其赋值给一个变量

# read是bash的内置函数
# read命令会从标准输入读取一行，并将其赋值给变量line。-r选项表示read将读取原生内容，所有字符都不会被转义，例如反斜线不会用于转义（只是反斜线）。输入重定向命令"<file"会打开文件并执行读操作，并且会将读取的内容以标准输入的形式提供给read命令。
read -r line < file
# read命令会删除特殊变量IFS所表示的字符。IFS是Internal Field Separator（内部字段分隔符）的缩写，它的值为用于分隔单词和行的字符组成的字符串。IFS的默认值为空格符、制表符和换行符组成的字符串。这意味着前导和尾随的空格符和制表符都会被删除。如果你想保留这些字符，你可以将IFS设置为空字符：
IFS= read -r line < file
# 利用外部程序head
line=$(head -1 file)
line=`head -1 file`

# 构造一个「畸形」测试用例
echo -n -e " 123 \x0a456" > file
# 逐行读文件 **有 BUG**
while read -r line; do
      # do something with $line
      echo "$line" | xxd -p
done < file
# 逐行读文件，防止行两端的空白字符被删除 **依然有 BUG**
while IFS= read -r line; do
      # do something with $line
      echo "$line" | xxd -p
done < file
# 文件读写的最佳实践
while IFS= read -r line || [[ -n "$line" ]]; do
      # do something with $line
      echo "$line" | xxd -p
done < file
```

### 18 符号编码

- ` backtick/backquote 反引号
- [ square bracket 方括号
- ' single quote 单引号
- " double quote 双引号
- _ underscore 下划线
- / slash 斜线（URL、*NIX 路径分隔符）
- \ backslash 反斜线（转义符号、Windows 路径分隔符）

```bash
# 16进制表示的 ascii 码: 7c，英文术语：vertical bar，Shell编程里的“管道操作符”
printf '%s' '|' | xxd  

# ref: https://www.zhihu.com/question/21747929/answer/319675621
printf '%s' '丨' | xxd # 16进制表示的 ascii 码: e4b8a8，汉语拼音：gun

# ref: https://practicaltypography.com/hyphens-and-dashes.html
# 16进制表示的 ascii 码: 2d，英文术语：hyphen，中文术语：连字符，俗称：短杠
printf '%s' '-' | xxd 

# 16进制表示的 ascii 码: e28093，英文术语：en dash
printf '%s' '–' | xxd 

# 16进制表示的 ascii 码: e28094，这是中文输入法打出来的破折号的一半，英文术语：em dash
printf '%s' '—' | xxd 
```