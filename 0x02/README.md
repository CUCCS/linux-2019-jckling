## Linux命令行使用基础

### 实验环境
Ubuntu18.04 Server
- 网卡：NAT、Host-Only
- 镜像：ubuntu-18.04.1-server-amd64.iso

安装 asciinema

```bash
# Install 
sudo apt install asciinema

# Link your install ID with your asciinema.org user account
asciinema auth
```

### vimtutor 操作录像

#### Lesson-1
<a href="https://asciinema.org/a/233867?autoplay=1"><img src="https://asciinema.org/a/233867.png" width="666"/></a>

#### Lesson-2
<a href="https://asciinema.org/a/233868?autoplay=1"><img src="https://asciinema.org/a/233868.png" width="666"/></a>

#### Lesson-3
<a href="https://asciinema.org/a/233875?autoplay=1"><img src="https://asciinema.org/a/233875.png" width="666"/></a>

#### Lesson-4
<a href="https://asciinema.org/a/233870?autoplay=1"><img src="https://asciinema.org/a/233870.png" width="666"/></a>

#### Lesson-5
<a href="https://asciinema.org/a/233871?autoplay=1"><img src="https://asciinema.org/a/233871.png" width="666"/></a>

#### Lesson-6
<a href="https://asciinema.org/a/233872?autoplay=1"><img src="https://asciinema.org/a/233872.png" width="666"/></a>

#### Lesson-7
<a href="https://asciinema.org/a/233873?autoplay=1"><img src="https://asciinema.org/a/233873.png" width="666"/></a>

### 自查清单

#### vim有哪几种工作模式？
- Normal
- Insert
- Visual

#### Normal模式下，从当前行开始，一次向下移动光标10行的操作方法？如何快速移动到文件开始行和结束行？如何快速跳转到文件中的第N行？
- 光标向下移动10行：10j
- 开始行：gg
- 结束行：G
- 第N行：Ngg

#### Normal模式下，如何删除单个字符、单个单词、从当前光标位置一直删除到行尾、单行、当前行开始向下数N行？
- 删除单个字符：x
- 删除单个单词：dw
- 删除到行尾：d$
- 删除单行：dd
- 删除往下N行：dNd

#### 如何在vim中快速插入N个空行？如何在vim中快速输入80个-？
- 插入N个空行：NO ESC
- 快速插入80个-：插入模式下 CTRL+O 80i- ESC

#### 如何撤销最近一次编辑操作？如何重做最近一次被撤销的操作？
- 撤销：u
- 重做：Ctrl+R

#### vim中如何实现剪切粘贴单个字符？单个单词？单行？如何实现相似的复制粘贴操作呢？
- 剪切单个字符：x
- 剪切单个单词：dw
- 剪切单行：d$
- 粘贴：P/p

#### 查看当前正在编辑的文件名的方法？查看当前光标所在行的行号的方法？
- Ctrl+G

#### 在文件中进行关键词搜索你会哪些方法？如何设置忽略大小写的情况下进行匹配搜索？如何将匹配的搜索结果进行高亮显示？如何对匹配到的关键词进行批量替换？
- /pattern
- :set ignorecase
- :set hlsearch     设置高亮查找
- :%s/p1/p2/g       将当前文件中全替换p1为p2

#### 在文件中最近编辑过的位置来回快速跳转的方法？
- ``
- `.

#### 如何把光标定位到各种括号的匹配项？例如：找到\(, \[, or \{对应匹配的),], or }
- %

#### 在不退出vim的情况下执行一个外部程序的方法？
- :!ls

#### 如何使用vim的内置帮助系统来查询一个内置默认快捷键的使用方法？如何在两个不同的分屏窗口中移动光标？
- :help w
- Ctrl+W w

## 描述环境

### 软件相关

- 操作系统发行版和内核信息
    - `uname -a`
    - `lsb_release -a`
- 系统中当前有谁在线
    - `w`
    - `who`
    - `users`
    - `last`
    - `history`操作序列
- 现在在运行的进程有哪些
    - `pstree -a`
    - `ps aux`
- 哪些进程在监听哪些端口
    - `netstat -tuxlp`
    - `lsof`
- 挂载点和文件系统
    - `mount`
    - `hier`
- 已安装应用软件列表、故障或问题发生前最近新安装的软件信息
    - `dpkg -l`
    - `/var/log/dpkg.log`
- 系统环境变量、当前用户环境变量
    - `/etc/profile`
    - `/home/username/.profile`
    - `systemctl show-environment`
- 故障/问题发生前后邻近的系统日志、应用程序日志等
    - `/var/log/`
- 系统自启动项有哪些，自启动机制分别是什么；系统定时任务有哪些，触发机制分别是什么
    - `systemctl status`
    - `ls /etc/cron*`
- 出问题应用程序的当前环境变量设置情况等
    - `env`
- 当前系统中哪些应用程序/进程在占用网络带宽？
    - `free -m`
    - `uptime`

### 网络相关
- 系统的IP地址、MAC地址信息
    - `ifconfig`
- ARP表 / 路由表 / hosts文件配置 / DNS服务器配置 / 代理服务器配置
    - `arp`
    - `route`
    - `/etc/resolv.conf`
- 防火墙规则表
    - `iptables -L`

### 硬件相关
- 硬件品牌、型号、购买渠道等
- CPU/内存/硬盘/网卡/外设和主要接口等硬件参数信息（例如是否使用了RAID？）
- 联网信息，例如使用的宽带接入方式、上下行带宽、运营商信息等
    - `lspci`
    - `dmidecode`
    - `ethtool`

## 本章命令速查

```bash
# 小火车 需安装
sl

# 查看当前路径
pwd

# 简短帮助 需安装
tldr tar

# 别名机制
alias

# 查看是否是bash函数
command -v cd
type cd
which cd
```
<a href="https://asciinema.org/a/234240?autoplay=1"><img src="https://asciinema.org/a/234240.png" width="666"/></a>

### 压缩与解压缩

```bash
gzip
bzip2
tar

# 需安装
zip
unzip
7z      # p7zip
rar     # p7zip-rar/unrar-free Linux上只支持解压缩

# 处理文件解压乱码
# -O 指定编码方案
unzip -O cp936 xxx.zip
```

### 文本处理

```bash
# 文本内容查找替换
awk

# 输出文件开始/末尾
head / tail

# 分割并输出
# -d 分隔符 -f 列
cut -d ":" -f 1,6 /etc/passwd

# 大小写转换
echo "hello world" | tr [:lower:] [:upper:]
# 删除指定字符
echo "hello world" | tr -d h

# 字符统计（字节数/字符数）
echo "hello world" | wc -w

# 查看字符十六进制
printf '%s' 'x' | xxd

# 删除文件名以-开头的文件
rm -- '-name'
rm './-name'
```

### 软件包管理

```bash
# 源
/etc/apt/sources.list

# 更新本地可用软件包信息数据库
apt update

# 更新已安装软件并解决依赖问题
apt dist-upgrade

# 更新已安装软件
apt upgrade

# 查找软件包
apt-cache search package
dpkg -S package
apt-file package        # 需安装
aptitude show package   # 需安装

# 确认软件包的版本和来源
apt-cache policy package

# 解决版本依赖
aptitude
apt-cache depends package

# 本地软件管理/查看
dpkg -l

# 删除已安装软件包和配置文件
apt purge

#  删除/var/cache/apt/archives/和/var/cache/apt/archives/partial/目录下除了lock文件之外的所有已下载（软件包）文件
apt clean

# 删除已安装软件包但不删除配置文件
apt remove

# 保留可能还有用的缓存
apt autoclean

# 删除已经没有软件依赖的软件包
apt autoremove

# 下载源码
apt source package
```

### 文件管理

```bash
# 查看隐藏文件
ls -a

# 显示修改时间
ls -l

# 创建空文件、修改访问时间
touch FILE

# 删除文件
rm FILE

# 磁盘擦除
shred FILE

# 创建软/硬链接
ln TARGET LINK_NAME

# 查找
find

# 分割
grep

# 查看文件状态
stat FILE

# 扩展名查找
# 文件查找 文件名忽略大小写
find /etc/ -iname "*.list" 
```

### 进程管理

```bash
# 查看当前进程
ps aux

# 查看进程树
pstree

# 查看进程PID
pidof sshd

# 运行时性能分析
top

# 交互式系统信息查看器
htop

# 杀死进程
kill / kill -9 / kill -s 9 / killall <process_imagename>

# 查看信号量
man 7 signal

# 伪文件目录 进程信息
/proc/
```


### 目录管理

```bash
# 查看文件分区 需安装
hier

# 列出目录内容
ls

# 创建目录
mkdir

# 递归创建目录
mkdir -p

# 删除目录
rm -rf

# 删除空目录
rmdir

# 伪文件目录 进程信息
/proc/
```

### 环境变量

```bash
# 环境变量
$PATH
# 当前用户主目录
$HOME
# 当前路径
$PWD

# 全局环境变量
/etc/profile

# 用户环境变量
~/.bashrc
~/.profile

# 显示当前用户环境变量
env
```

### 网络调试

```bash
# ARP
arp

# 网卡信息
ifconfig

# 查看邻居网络
ip neigh

# 路由信息
route

# 网络信息，网络连接等
netstat

# 列出当前打开的文件
lsof

# 网络配置
netplan

# 网络诊断 查看路由网络连通性
mtr hostname

# 显示设备信息
ethtool

# 转储网络流量
tcpdump

# 第三方工具
dstat
traceroute

# 配置文件
/etc/hosts

# DNS解析
/etc/resolv.conf

# 网卡
# 建议使用 netplan
/etc/network/interfaces
```

## 参阅
- [awesome-cheatsheets/editors/vim.txt](https://github.com/skywind3000/awesome-cheatsheets/blob/master/editors/vim.txt)
- [SED(Stream EDitor)](https://explainshell.com/explain?cmd=sed)
- [Sharing & embedding](https://asciinema.org/docs/embedding)