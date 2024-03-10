#!/bin/bash
# 安全的rm脚本

dir=$(date "+%y_%m_%d")
dir="/Users/leo/.Trash/$dir"
#echo $dir
if [ ! -d $dir ];then
    mkdir -p $dir
fi


# is_f=false
is_f=true
args=""


f_remove() {
    for i in ${args}; do
        if [ -d "$i" -o -f "$i" -o -L "$i" ];then
            name=`basename $i`
            if [ -d "$dir/$name" -o -f "$dir/$name" -o -L "$dir/$name" ];then
                new_name="$dir/${name}_$(date '+%T')"
                mv $i $new_name && echo "$i deleted,you can see in $new_name"
            else
                mv $i $dir && echo "$i deleted,you can see in $dir/$i"
            fi
        else
            echo "参数错误"
        fi
    done
}


remove() {
    for j in ${args}; do
        if [ -d "$j" -o -f "$j" -o -L "$j" ];then
            name=`basename $j`
            echo "Remove $name?[y/n]"
            read -s -n1 bool
            if [[ $bool == [Yy] ]];then
                if [ -d "$dir/$name" -o -f "$dir/$name" -o -L "$dir/$name" ];then
                    new_name="$dir/${name}_$(date '+%T')"
                    mv $j $new_name && echo "$j deleted,you can see in $new_name"
                else
                    mv $j $dir && echo "$j deleted,you can see in $dir/$j"
                fi
            fi
        else
            echo "参数错误"
        fi
    done
}


while [ "$1" ]; do
    case "$1" in
        -fr|-rf|-f)
            is_f=true
            shift
            ;;
        -i|-r)
            is_f=false
            shift
            ;;
        *)
            args="$1 $args"
            shift
            ;;
    esac
done


if [[ $is_f  = true ]]; then
    f_remove
else
    remove
fi
