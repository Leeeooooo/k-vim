#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit

# 定义需要操作的文件列表
declare -a FILES_TO_LINK=(
    "vim"
    "p10k.zsh"
    "tmux.conf"
    "vimrc"
    "vimrc.bundles"
    "zshrc"
)

# 解析参数
show_help() {
    cat << EOF
用法：install.sh [选项]
    --install       安装vim配置文件，默认选项
    --update        更新vim插件
    --help          显示帮助信息
示例：
    install.sh --install
    install.sh --help
EOF
}

backup_and_unlink() {
    local target_dir="$HOME/.config_$(date "+%Y%m%d")"
    mkdir -p "$target_dir"
    for i in "${FILES_TO_LINK[@]}"; do
        local source_file="$HOME/.$i"
        local target_file="$target_dir/$i"
        if [[ -e $source_file && ! -L $source_file ]]; then
            echo "  备份文件: $source_file => $target_file"
            mv "$source_file" "$target_file"
        fi
        if [[ -h $source_file ]]; then
            echo "  解除符号链接: $source_file"
            unlink "$source_file"
        fi
    done
}

create_symlinks() {
    for i in "${FILES_TO_LINK[@]}"; do
        local source_file="$CURRENT_DIR/$i"
        # 如果文件名为 vim，则源文件为 $CURRENT_DIR
        if [[ "$i" == "vim" ]]; then
            local source_file="$CURRENT_DIR"
        # 如果文件名为 zshrc，则根据当前系统判断源文件
        elif [[ "$i" == "zshrc" ]]; then
            local source_file="$CURRENT_DIR/zshrc.$(uname -s)"
        else
            local source_file="$CURRENT_DIR/$i"
        fi
        local target_file="$HOME/.$i"
        if [[ -e $source_file ]]; then
            echo "  创建符号链接: $source_file => $target_file"
            ln -snf "$source_file" "$target_file"
        else
            echo "  源文件不存在，跳过: $source_file"
        fi
    done
}

install_dependencies() {
    # 检测操作系统类型
    case "$(uname -s)" in
        Linux*)
            echo "  当前为 Linux 系统, 使用 apt 安装软件包..."
            sudo apt update -qq
            sudo apt install -yqq fzf nodejs npm silversearcher-ag
            sudo pip3 install -q black flake8
            ;;

        Darwin*)
            echo "  当前为 macOS 系统, 使用 brew 安装软件包..."
            brew install black flake8 fzf node the_silver_searcher
            ;;

        *)
            echo "  不支持的操作系统."
            return 1
            ;;
    esac
}

install_plugs() {
    # system_shell=$SHELL
    # export SHELL="/bin/sh"
    vim -u "$HOME/.vimrc.bundles" +PlugInstall! +PlugClean! +qall
    # export SHELL=$system_shell

    vim -c 'echo "正在安装coc.nvim插件，请稍候..."' +'CocInstall -sync coc-syntax coc-snippets coc-pairs coc-highlight coc-git coc-emmet coc-yaml coc-vimlsp coc-pyright coc-json coc-cmake coc-clangd coc-protobuf coc-markdownlint coc-sh' +qall
}

install() {
    echo "Step1: 备份当前配置"
    backup_and_unlink

    echo "Step2: 创建配置"
    create_symlinks

    echo "Step3: 安装前置依赖包"
    install_dependencies

    echo "Step4: 安装 Vim-plug 及插件"
    install_plugs

    echo "安装完毕，请手动运行以下 Vim 命令来安装 clangd 语言服务器："
    echo "vim tmp.cpp +'CocCommand clangd.install'"
}

update() {
    echo "更新 Vim-plug 插件及 coc-nvim 插件"
    vim +PlugUpgrade +PlugUpdate! +PlugClean! +CocUpdateSync +qall

    echo "更新完毕！"
}

main() {
    case "$1" in
        --help)
            show_help
            ;;
        --install)
            install
            ;;
        --update)
            update
            ;;
        *)
            show_help
            ;;
    esac
}

main "$@"
