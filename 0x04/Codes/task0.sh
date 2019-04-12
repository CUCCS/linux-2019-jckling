#!/usr/bin/env bash

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
  bash $1 -f test.jpg -q 50      				compress jpg image quality 50
  bash $1 -f test.svg -c         				convert svg to jpg
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

# avaliable type
intersect() {
  tarr=("$@")
  if [[ ! $arr ]];then r=${tarr[*]};
  else
    r=()
    for i in "${tarr[@]}";do
      if [[ "${arr[*]}" == *"$i"* ]];then
        r+=("$i")
      fi
    done
  fi
  arr=${r[*]}
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
      t=("JPEG")
      intersect "${t[@]}"
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
      t=("JPEG" "PNG")
      intersect "${t[@]}"
      ;;
    t)
      is_mark=true
      text="$OPTARG"
      t=("JPEG" "PNG")
      intersect "${t[@]}"
      ;;
    p)
      is_rename=true
      is_prefix=true
      prefix="$OPTARG"
      t=("JPEG" "PNG" "SVG")
      intersect "${t[@]}"
      ;;
    s)
      is_rename=true
      suffix="$OPTARG"
      t=("JPEG" "PNG" "SVG")
      intersect "${t[@]}"
      ;;
    c)
      is_convert=true
      t=("PNG" "SVG")
      intersect "${t[@]}"
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
    format="$(identify -format "%m" "$d$tmp")"
    if [[ "${arr[*]}" == *"$format"* ]];then
  	para=""
        name=$tmp
  	if [[ $is_compress ]];then para="${para} -quality $quality";fi
  	if [[ $is_resize ]];then para="${para} -resize "${scale}%"";fi
    	if [[ $is_convert ]];then name="${name%.*}.jpg";fi
    	if [[ $is_rename ]];then
	  if [[ $is_prefix ]];then
	    name="$prefix$name"
	  else
	    name="${name%.*}${suffix}.${name##*.}"
	  fi
	fi
    	if [[ $is_mark ]];then
	  h="$(identify -format "%h" "$d$tmp")"
	  w="$(identify -format "%w" "$d$tmp")"
	  s=$(( h < w ? h/10 : w/10))
	  para="${para} -pointsize $s -fill yellow -gravity center -draw \"text 10,10 '$text' \" "
        fi
	cmd="convert $d$tmp $para $d$name"
	eval "$cmd"
    fi
  done
fi
