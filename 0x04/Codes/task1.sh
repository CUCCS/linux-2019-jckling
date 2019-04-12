#!/usr/bin/env bash

# png/svg to jpg
formatting() {
  format="$(identify -format "%m" "$2$1")"
  if [[ $format == "PNG" ]] || [[ $format == "SVG" ]]; then
    convert "$2$1" "$2${1%.*}.jpg"
    tmp="${1%.*}.jpg"
  fi
}

# add prefix or suffix
prefix_suffix() {
  format="$(identify -format "%m" "$2$1")"
  if [[ $format == "JPEG" ]] || [[ $format == "PNG" ]] || [[ $format == "SVG" ]];then
    if [[ $is_prefix ]]; then
      mv "$2$1" "$2$prefix$1"
      tmp="$prefix$1"
    else
      mv "$2$1" "$2${1%.*}${suffix}.${1##*.}"
      tmp="${1%.*}${suffix}.${1##*.}"
    fi
  fi
}

# jpeg/jpg
compress() {
  if [[ "$(identify -format "%m" "$2$1")" == "JPEG" ]]; then
    convert "$2$1" -quality "$quality" "${2}quality_${quality}_$1"
    tmp="quality_${quality}_$1"
  fi
}

# jpeg/jpg/png
resize() {
  format="$(identify -format "%m" "$2$1")"
  if [[ $format == "JPEG" ]] || [[ $format == "PNG" ]];then
    convert "$2$1" -resize "${scale}%" "${2}resized_${scale}_$1"
    tmp="resized_${scale}_$1"
  fi
}

# add text watermark
watermark() {
  format="$(identify -format "%m" "$2$1")"
  if [[ $format == "JPEG" ]] || [[ $format == "PNG" ]];then
    h="$(identify -format "%h" "$2$1")"
    w="$(identify -format "%w" "$2$1")"
    s=$(( h < w ? h/10 : w/10 ))
    convert "$2$1" -pointsize "$s" -fill yellow -gravity center -draw "text 10,10 '$text'" "${2}marked_$1"
    tmp="marked_$1"
  fi
}

# help information
usage() {
  cat <<END_EOF
usage: bash $1 -f <filename|filepath> [-q <quality>] [-r <scale>] ...

Jck's bash script for task 1, remember to back up your origin images first!
Attention! If image type is not supported, the operation will be skipped!

optional arguments:
  -f            filename or filepath
  -q            jpeg/jpg compress quality
  -r            resize by scale (only jpeg/jpg/png)
  -t            draw text watermark in center (only jpeg/jpg/png)
  -p            add prefix in filename (only jpeg/jpg/png/svg)
  -s            add suffix in filename (only jpeg/jpg/png/svg)
  -c            convert png/svg to jpg
  -h            show this help message and exit

for example:
  bash $1 -f test.jpg -q 50      			        compress jpg image quality 50
  bash $1 -f test.svg -c         			        convert svg to jpg
  bash $1 -f test.jpeg -q 50 -r 50 -t "CUC"		compress jpeg and resize by 50% and add watermark

END_EOF
}

# check environment
check_env() {
  if ! type -p convert &>/dev/null; then
    printf '%s\n' "error: convert is not installed, exiting..."
    exit 1
  fi    
}

# file or path
check() {
  if  [[ -d $1 ]]; then
    echo "$1 is a directory" > /dev/null
  elif [[ -f $1 ]]; then
    echo "$1 is a file" > /dev/null
  else
    echo "$1 is not valid"
    exit 1
  fi
}

# remove temp file
clean() {
  if [[ "$tmp" != "$bk" ]];then
    rm "$1$bk"
    bk="$tmp"
  fi
}

# params
while getopts "f:q:r:t:p:s:ch" opt; do
  case $opt in
    f)
      path="$OPTARG"
      check "$path"
      ;;
    q)
      is_compress=true
      quality="$OPTARG"
      ;;
    r)
      is_resize=true
      scale="$OPTARG"
      if [[ "$scale" == *[!0-9]* ]];then
	echo "not integer"
	exit 1
      elif [[ $scale -le 0 ]];then
	echo "negative or zero image size"
	exit 1
      fi
      ;;
    t)
      is_mark=true
      text="$OPTARG"
      ;;
    p)
      is_rename=true
      is_prefix=true
      prefix="$OPTARG"
      ;;
    s)
      is_rename=true
      suffix="$OPTARG"
      ;;
    c)
      is_convert=true
      ;;
    h|?)
      usage "$0"
      exit 1
      ;;
  esac
done

# start from here...
check_env

# save original file or not
if [[ $path ]];then
  files=$(ls "$path")
  d="${path%/*}/";
  for f in $files;do
    tmp="${f##*/}"
    bk=$tmp
    if [[ $is_compress ]];then compress "$tmp" "$d";fi
    if [[ $is_resize ]];then clean "$d"; resize "$tmp" "$d";fi
    if [[ $is_convert ]];then clean "$d"; formatting "$tmp" "$d";fi
    if [[ $is_mark ]];then clean "$d"; watermark "$tmp" "$d";fi
    if [[ $is_rename ]];then clean "$d"; prefix_suffix "$tmp" "$d";fi
    clean "$d"
  done
fi
