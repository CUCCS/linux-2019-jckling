
实验中用到的一些命令

```bash
### Pass ###
# # 重启系统
# systemctl reboot

# # 关闭系统，切断电源
# systemctl poweroff

# # CPU停止工作
# systemctl halt

# # 暂停系统
# systemctl suspend

# # 让系统进入冬眠状态
# systemctl hibernate

# # 让系统进入交互式休眠状态
# systemctl hybrid-sleep

# # 启动进入救援状态（单用户状态）
# systemctl rescue

### Start ###
# 查看版本
systemd --version

# 查看位置
whereis systemd

# 查看进程
ps aux | grep systemd

# 查看启动耗时
systemd-analyze

# 查看每个服务的启动耗时
systemd-analyze blame

# 显示瀑布状的启动过程流/关键链
systemd-analyze critical-chain

# 显示指定服务的启动流/关键链
systemd-analyze critical-chain sshd.service

# 显示当前主机的信息
hostnamectl

# 设置主机名
hostnamectl set-hostname VM-CUC
hostnamectl status

# 查看本地化设置
localectl

# 列出本地化参数
localectl list-locales

# # 设置本地化参数
# localectl set-locale LANG=en_GB.utf8
# localectl set-keymap en_GB

# 查看当前时区设置
timedatectl

# 显示所有可用的时区
timedatectl list-timezones                                        

# 设置当前时区
timedatectl set-timezone Asia/Shanghai

# 列出当前 session
loginctl list-sessions

# 列出 session-1 状态
loginctl session-status 1

# 列出 session 属性
loginctl show-session

# 列出当前登录用户
loginctl list-users

# 列出显示指定用户的信息
loginctl show-user mosom

### Unit ###
# 列出正在运行的 Unit
systemctl list-units

# 列出所有 Unit 包括没有找到配置文件的或者启动失败的
systemctl list-units --all

# 列出所有没有运行的 Unit
systemctl list-units --all --state=inactive

# 列出所有加载失败的 Unit
systemctl list-units --failed

# 列出所有正在运行的、类型为 mount 的 Unit
systemctl list-units --type=mount

# 显示系统状态
systemctl status

# 显示单个 Unit 的状态
sysystemctl status sshd.service

# 显示某个 Unit 是否正在运行
systemctl is-active sshd.service

# 显示某个 Unit 是否处于启动失败状态
systemctl is-failed sshd.service

# 显示某个 Unit 服务是否建立了启动链接
systemctl is-enabled sshd.service

# 取消开机启动
systemctl disable sshd.service

# 激活开机启动
systemctl enable ssh

### Start/Stop/Restart ###
# root权限
sudo su -

# 立即停止一个服务
systemctl stop setvtrgb.service

# 立即启动一个服务
systemctl start setvtrgb.service

# 重启一个服务
systemctl restart setvtrgb.service

# 杀死一个服务的所有子进程
systemctl kill setvtrgb.service

# 重新加载一个服务的配置文件
systemctl reload sshd.service

# 重载所有修改过的配置文件
systemctl daemon-reload

# 显示某个 Unit 的所有底层参数
systemctl show sshd.service

# 显示某个 Unit 的指定属性的值
systemctl show -p CPUShares sshd.service

# 设置某个 Unit 的指定属性
systemctl set-property sshd.service CPUShares=500
systemctl show -p CPUShares sshd.service
ls /etc/systemd/system/sshd.service.d/

# 列出一个 Unit 的所有依赖
systemctl list-dependencies sshd.service

# 列出一个 Unit 的所有依赖并展开 Target
systemctl list-dependencies --all sshd.service

### Unit files ###
# 列出所有可用单元
systemctl list-unit-files

# 列出系统挂载点
systemctl list-unit-files --type=mount

# 列出所有可用系统套接口
systemctl list-unit-files --type=socket

# 查看配置文件的内容
systemctl cat sshd.service

# 查看当前系统的所有 Target
systemctl list-unit-files --type=target

# 查看启动时的默认 Target
# 列出当前使用的运行等级
systemctl get-default

# 查看一个 Target 包含的所有 Unit
systemctl list-dependencies multi-user.target

# 设置启动时的默认 Target
systemctl set-default multi-user.target

# 切换 Target 时，默认不关闭前一个 Target 启动的进程
# systemctl isolate 命令改变这种行为
# 关闭前一个 Target 里面所有不属于后一个 Target 的进程
systemctl isolate multi-user.target

# 按等级列出控制组
systemd-cgls

# 按CPU、内存、输入和输出列出控制组
systemd-cgtop

### Journalctl ###
# 日志的配置文件是/etc/systemd/journald.conf

# 查看所有日志（默认情况下 ，只保存本次启动的日志）
journalctl

# 查看内核日志（不显示应用日志）
journalctl -k

# 查看系统本次启动的日志
journalctl -b
journalctl -b -0

# 查看上一次启动的日志（需更改设置）
journalctl -b -1

# 查看指定时间的日志
journalctl -S "20 min ago"
journalctl -S yesterday

# 显示尾部的最新10行日志
journalctl -n

# 显示尾部指定行数的日志
journalctl -n 20

# 实时滚动显示最新日志
journalctl -f

# 查看指定服务的日志
journalctl /bin/systemd

# 查看指定进程的日志
ps aux | grep sshd 选root
journalctl _PID=1 

# 查看某个路径的脚本的日志
journalctl /bin/bash

# 查看指定用户的日志
journalctl _UID=1000 -S today

# 查看某个 Unit 的日志
journalctl -u ssh.service -S today

# 实时滚动显示某个 Unit 的最新日志
journalctl -u ssh.service -f

# 查看指定优先级（及其以上级别）的日志，共有8级
# 0: emerg
# 1: alert
# 2: crit
# 3: err
# 4: warning
# 5: notice
# 6: info
# 7: debug
journalctl -p warning -b

# 标准输出
journalctl --no-pager

# 以 JSON 格式（单行）输出
journalctl -b -p warning -u ssh.service -o json

# 以 JSON 格式（多行）输出，可读性更好
journalctl -b -u ssh.service -o json-pretty

# 显示日志占据的硬盘空间
journalctl --disk-usage

# 指定日志文件占据的最大空间
journalctl --vacuum-size=1G

# 指定日志文件保存多久
journalctl --vacuum-time=1years
```