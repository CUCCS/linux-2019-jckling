#!/usr/bin/env bash

# 信息
info() {
  # 字段数 字段 行数（除了第一行）
  awk '{ if(NR==1){print "total fields: "NF; print} } END{ print "total records: "NR-1 }' web_log.tsv
}

# 统计访问来源主机TOP 100和分别对应出现的总次数
top_hosts() {
  awk -F '\t' 'NR>1 { hosts[$1]++; } END{ for(k in hosts){print hosts[k]"\t"k"\t\n";} }' web_log.tsv | sort -g -k1 -r | head -100
}

# 统计访问来源主机TOP 100 IP和分别对应出现的总次数
top_ips() {
  awk -F '\t' 'NR>1 { if(match($1, /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/) || match($1,/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/)){hosts[$1]++;} }
  END{ for(k in hosts){print hosts[k]"\t"k"\t\n";} }' web_log.tsv | sort -g -k1 -r | head -100
}

# 统计最频繁被访问的URL TOP 100
top_urls() {
  awk -F '\t' 'NR>1 { urls[$5]++;} END{ for(k in urls){print urls[k]"\t"k"\t\n";} }' web_log.tsv | sort -g -k1 -r | head -100
}

# 统计不同响应状态码的出现次数和对应百分比
states() {
  awk -F '\t' 'NR>1 { response[$6]++;} END{ for(k in response){ p=100*response[k]/(NR-1); printf("%s\t%.6f%%\t",k,p); print response[k]"\t";} }' web_log.tsv
}

# 统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
code() {
tmp="$(awk -F '\t' '{ if(match($6,/^4[0-9]{2}$/)){urls[$6][$5]++;} }
END{ 
  for(k1 in urls){
    for(k2 in urls[k1]){
      print k1, urls[k1][k2], k2;
    }
  }
}' web_log.tsv | tee >(sort -k1,1r -k2,2gr | head -10) >(sort -k1,1 -k2,2gr | head -10) > /dev/null)"
  a=0
  for t in $tmp;do
    a=$((a+1))
    if [[ $a%3 -eq 0 ]];then
        printf "%s\t\n" "$t"
    else
      printf "%s\t" "$t"
    fi
  done
}

# 给定URL输出TOP 100访问来源主机
top() {
  VAR=$1
  awk -F '\t' 'NR>1{ if($5==V){hosts[$1]++;} } END{ for(k in hosts){print hosts[k]"\t"k"\t\n";} }' V="$VAR" web_log.tsv | sort -g -k1 -r | head -100
}

# 帮助信息
usage() {
  cat <<END_EOF
usage: bash $1 [-h] [-u <url>] ...

Jck's bash script for task 3

optional arguments:
  -i		show information about web_log.tsv
  -a            top 100 hosts
  -b            top 100 ips
  -c            top 100 urls
  -d            state codes statistics
  -e            top 10 url with state codes 4xx
  -u            specify url and display top 100 hosts
  -h            show this help message and exit

for example:
  bash $1 -u "/ksc.html"	display top 100 access hosts

END_EOF
}

# 参数处理
while getopts "iabcdeu:h" opt; do
  case $opt in
    i) info;;
    a) top_hosts;;
    b) top_ips;;
    c) top_urls;;
    d) states;;
    e) code;;
    u) top "$OPTARG";;
    h|?)
      usage "$0"
      exit 1
      ;;
  esac
done

