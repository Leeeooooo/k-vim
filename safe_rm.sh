#!/bin/bash
# 安全的rm脚本

# 创建今日的备份目录
create_backup_dir() {
    local dir="/Users/leo/.Trash/$(date "+%Y_%m_%d")"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
    echo "$dir"
}

# 标记是否需要用户确认删除，默认为不需要确认
is_f=true
# 文件名参数数组
declare -a args

# 删除或移动到备份目录的函数
manage_files() {
    local backup_dir=$(create_backup_dir)
    for i in "${args[@]}"; do
        if [ -e "$i" ] || [ -L "$i" ]; then
            local name=$(basename -- "$i")
            local new_name="${name}_$(date '+%H-%M-%S')"

            # 如果备份目录中已存在同名文件，则添加随机数以避免冲突
            if [ -e "$backup_dir/$new_name" ] || [ -L "$backup_dir/$new_name" ]; then
                new_name="${new_name}_$RANDOM"
            fi

            # 如果需要确认，提示用户是否删除
            if [[ $is_f == false ]]; then
                echo "Remove $name?[y/n]"
                read -s -n1 bool
                echo # 输出一个新行
                if [[ $bool != [Yy] ]]; then
                    continue # 如果用户选择不删除，跳过当前文件
                fi
            fi

            mv -- "$i" "$backup_dir/$new_name" && echo "Moved to Trash: $backup_dir/$new_name"
        else
            echo "参数错误: 文件 '$i' 不存在或无法访问."
        fi
    done
}

# 解析命令行参数
while [ "$1" ]; do
    case "$1" in
        -fr|-rf|-f)
            is_f=true
            shift ;;
        -i|-r)
            is_f=false
            shift ;;
        *)
            args+=("$1")
            shift ;;
    esac
done

# 处理文件删除或移动
manage_files

