#!/usr/bin/env bash

# 信息
info() {
  # 字段数 字段 行数（除了第一行）
  awk '{ if(NR==1){print "total fields: "NF; print} } END{ print "total records: "NR-1 }' worldcupplayerinfo.tsv
}

# 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
num() {
  awk -F '\t' 'BEGIN{ a=0; b=0; c=0; }
  NR>1 {
    if($6<20) {a++;}
    else if($6<=30) {b++;}
    else {c++;}
  }
  END{ 
    t=a+b+c;
    printf("[<20]\t%d\t%.6f\t\n",a,a/t);
    printf("[20,30]\t%d\t%.6f\t\n",b,b/t);
    printf(">30\t%d\t%.6f\t\n",c,c/t);
  }' worldcupplayerinfo.tsv
}

# 统计不同场上位置的球员数量、百分比
pos() {
  awk -F '\t' 'BEGIN{t=0;} NR>1{ pos[$5]++; t++; }
  END{ 
    for(p in pos){printf("%s:\t%.6f\t%d\t\n",p,pos[p]/t,pos[p]);}
  }' worldcupplayerinfo.tsv
}


# 名字 $9 是否有重复
dup() {
  awk -F '\t' 'NR>1 { names[$9]++; }
  END{ a=0; for(n in names){if(names[n]>1){print "duplicate names: "n,names[n];}a+=names[n];} print "total palyers: "a; }' worldcupplayerinfo.tsv
}


# 名字最长的球员是谁？名字最短的球员是谁？
name() {
  awk -F '\t' 'BEGIN{ max=0; min=999; }
  NR>1 { 
    l=length($9);
    names[$9]=l;
    max=l>max?l:max;
    min=l<min?l:min; 
  }
  END{ 
    for(k in names){ 
      if(names[k]==max){ print "longest name: "k; }
      else if(names[k]==min){ print "shortest name: "k; }
    }
  }' worldcupplayerinfo.tsv
}

# 年龄最大的球员是谁？年龄最小的球员是谁？
age() {
  awk -F '\t' 'BEGIN{ max=0; min=999; }
  NR>1 {
    names[$9]=$6;
    max=$6>max?$6:max;
    min=$6<min?$6:min;
  }
  END{
    for(k in names){
        if(names[k]==max){
            print "largest age: "names[k]"\t""name: "k"\t";
        }
        else if(names[k]==min){
            print "smallest age: "names[k]"\t""name: "k"\t";
        }
    }
  }' worldcupplayerinfo.tsv
}

# 帮助信息
usage() {
  cat <<END_EOF
usage: bash $1 [-h] [-i] ...

Jck's bash script for task 2

optional arguments:
  -i		show information about worldcupplayerinfo.tsv
  -a            count the number and percentage of players in different age ranges
  -b            count the number and percentage of players on different positions
  -c            show duplicate names
  -d            show the longest and shortest names of palyers
  -e            show the oldest and youngest players
  -h            show this help message and exit

for example:
  bash $1 -i        show information about worldcupplayerinfo

END_EOF
}

# 参数处理
while getopts "iabcdeh" opt; do
  case $opt in
    i)
      info
      ;;
    a)
      num
      ;;
    b)
      pos
      ;;
    c)
      dup
      ;;
    d)
      name
      ;;
    e)
      age
      ;;
    h|?)
      usage "$0"
      exit 0
      ;;
  esac
done

