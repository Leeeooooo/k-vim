"===============================================================================
" Author: yu.li
" Last Modify: 2025-05-13
" Sections:
"       -> Initial Plugin 加载插件
"       -> General Settings 基础设置
"       -> Display Settings 界面格式设置
"       -> FileEncode Settings 文件编码设置
"       -> HotKey Settings  自定义快捷键
"       -> Type Settings  文件类型设置
"       -> Theme Settings  主题设置
"===============================================================================

"===============================================================================
" Initial Plugin 加载插件
"===============================================================================
let mapleader = ','             " leader键
let g:mapleader = ','           " leader键
if has('vim_starting')
  set nocompatible
  filetype off

  " 插件目录 & 加载
  call plug#begin('~/.vim/bundle')
    source ~/.vimrc.bundles
  call plug#end()

endif

" 文件类型 & 缩进 & 语法高亮
filetype plugin indent on
syntax on

"===============================================================================
" General Settings 基础设置
"===============================================================================
set history=2000                " 命令历史
set autoread                    " 文件外部修改自动载入
set nobackup noswapfile         " 不要备份/交换文件
set hidden                      " 缓冲区可后台隐藏
set viminfo^=%                  " 记住光标最后位置等
set magic                       " 增强正则
set backspace=eol,start,indent  " backspace 智能
set whichwrap+=<,>,h,l          " 行首/尾方向可换行
set wildignore+=*.swp,*.bak,*.pyc,*.class,.svn,*.o,*~
set wildmode=list:longest       " 命令行补全模式
set wildmenu                    " 命令行补全增强
set ttymouse=sgr                " 鼠标支持
set mouse=a                     " 启用鼠标
set mousehide                   " 输入模式隐藏鼠标
set title                       " 终端标题变化
set noerrorbells novisualbell   " 关掉蜂鸣/闪屏
" set t_vb=                       " 关掉闪屏
set tm=500                      " 键盘等待时间(ms)
set clipboard=unnamedplus       " 共享系统剪贴板
set ttyfast                     " 认为终端很快
set lazyredraw                  " 只在必要时重绘
set nofixendofline              " 不自动在行尾添加换行符
" set nrformats=                  " 00x增减数字时使用十进制

" 快速重载 vimrc
autocmd BufWritePost $MYVIMRC     source $MYVIMRC
autocmd BufWritePost ~/.vimrc.bundles source ~/.vimrc.bundles

" 恢复上次编辑位置
autocmd BufReadPost *
      \ if line("'\"")>1 && line("'\"")<=line("$") |
      \   exe "normal! g'\"" |
      \ endif

set completeopt=longest,menu      " IDE 式补全
set pumheight=12                  " 补全菜单高度
autocmd InsertLeave * if pumvisible()==0|pclose|endif

"===============================================================================
" Display Settings 界面格式设置
"===============================================================================
set number ruler                " 显示行号 & 光标信息
set signcolumn=yes              " 显示符号列
set cursorline cursorcolumn     " 高亮行/列
set noshowmode                  " 不重复 showmode
set showcmd                     " 显示命令
set laststatus=2                " 始终显示状态栏
set statusline=%<%f\ %h%m%r\ [%{&fenc}%{(&bomb?',BOM':'')}]\ %=%l,%c\ (%P)
" set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set scrolloff=7                 " 光标上下保留行数
" set winwidth=79                 " 窗口宽度
set nowrap                      " 禁止自动换行
set showmatch matchtime=2       " 括号匹配高亮
set hlsearch incsearch ignorecase  " 高亮 & 增量 & 忽略大小写
" set smartcase                 " 智能大小写
" 防止tmux显示异常
" if &term =~ '256color'
"   set t_ut=
" endif

" 折叠
set foldenable
" 折叠方法
" manual    手工折叠
" indent    使用缩进表示折叠
" expr      使用表达式定义折叠
" syntax    使用语法定义折叠
" diff      对没有更改的文本进行折叠
" marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}
set foldmethod=indent foldlevel=99
let g:FoldState=0
nnoremap <leader>zz :call ToggleFold()<CR>
function! ToggleFold()
  if g:FoldState==0
    normal! zM | let g:FoldState=1
  else
    normal! zR | let g:FoldState=0
  endif
endfunction

" 缩进
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set smarttab autoindent smartindent shiftround

"===============================================================================
" FileEncode Settings 文件编码设置
"===============================================================================
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileformats=unix,dos,mac
set termencoding=utf-8
set helplang=cn
" 文本自动格式选项
set formatoptions+=mB

"===============================================================================
" HotKey Settings  自定义快捷键
"===============================================================================

" wrap 模式下按屏幕行移动
nnoremap k  gk
nnoremap j  gj
nnoremap gk k
nnoremap gj j

" 窗口导航
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Quickfix 窗口回车 & 分屏映射
autocmd FileType qf nnoremap <buffer> <CR> <CR>
autocmd FileType qf nnoremap <buffer> v <C-w><Enter><C-w>L
autocmd FileType qf nnoremap <buffer> s <C-w><Enter><C-w>K

" Command-line 窗口回车
autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>

" 缓冲区导航
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

" Tab 管理
nnoremap <C-t> :tabnew<CR>
nnoremap <leader>th :tabfirst<CR> | nnoremap <leader>tl :tablast<CR>
nnoremap <leader>tj :tabnext<CR>  | nnoremap <leader>tk :tabprevious<CR>
nnoremap <leader>te :tabedit<cr>
nnoremap <leader>td :tabclose<cr>
nnoremap <leader>tm :tabm<cr>
for i in range(1,9)
  execute 'nnoremap <leader>' . i . ' ' . i . 'gt'
endfor
nnoremap <leader>0 :tablast<CR>
" 记录最后一次活动的 Tab 页
let g:last_active_tab = 1
" <leader>tt 切换到上一次活动的 Tab
nnoremap <silent> <leader>tt :execute 'tabnext ' . g:last_active_tab<CR>
" 在离开任何 Tab 时更新 g:last_active_tab
autocmd TabLeave * let g:last_active_tab = tabpagenr()

" 普通模式常用
nnoremap ; :                   " 快捷进入命令行
nnoremap J G
nnoremap H ^
nnoremap L $
nnoremap K gg
nnoremap Y y$                  " Y 同其它大写行为
nnoremap ' `                   " 交换 ' 和 `
nnoremap ` '                   " 交换 ` 和 '
nnoremap U <C-r>               " U 重做
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>sa ggVG       " 全选
" 重新选中并高亮上一次插入/修改的内容
nnoremap <silent> gv `[v`]

" 插入模式
inoremap kj <Esc>               " kj 退回 Normal
inoremap <C-e> <C-o>A           " 跳到行尾后插入
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

" Cmd 模式
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

" 搜索 & 跳转保持居中
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
noremap <silent> <leader>/ :nohlsearch<CR>
" 智能正则搜索
nnoremap / /\v
vnoremap / /\v

" 选区缩进后保持选中
vnoremap < <gv
vnoremap > >gv

" 多光标移动（visual block）
vnoremap <silent> <S-J> :m '>+1<CR>gv=gv
vnoremap <silent> <S-K> :m '<-2<CR>gv=gv

" Zoom 窗口
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd | let t:zoomed=0
  else
    let t:zoom_winrestcmd=winrestcmd()
    resize | vertical resize | let t:zoomed=1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <Leader>z :ZoomToggle<CR>

" sudo 写文件
cmap w!! w !sudo tee >/dev/null %

" 滚动加速
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" switch # *
nnoremap # *
nnoremap * #

" 禁用 c 键
noremap c <nop>
noremap C <nop>

" F1 废弃这个键,防止调出系统帮助
noremap <F1> <Esc>
inoremap <F1> <Esc>
" F2 显示可打印字符开关
nnoremap <F2> :set list! list?<CR>
" F3 换行开关
nnoremap <F3> :set wrap! wrap?<CR>

"===============================================================================
" Type Settings  文件类型设置
"===============================================================================
augroup FileTypeSettings
  autocmd!
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab ai
  autocmd FileType ruby,html,css,xml,yaml,json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
  autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown setlocal filetype=markdown.mkd
  autocmd BufRead,BufNewFile *.part setlocal filetype=html
  autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
  " PHP: 关掉 showmatch 的 <:
  autocmd BufWinEnter *.php set mps-=<:
augroup END

" for # indent, python文件中输入新行时#号注释不切回行首
autocmd BufNewFile,BufRead *.py inoremap # X<c-h>#

" New file 自动插入文件头
augroup AutoFileHead
  autocmd!
  autocmd BufNewFile *.py,*.sh,*.c,*.cpp,*.cc,*.h,*.java,*.rb call AutoSetFileHead()
augroup END

function! AutoSetFileHead()
  let ft=&filetype
  if ft=='python'
    call setline(1, '#!/usr/bin/env python')
    call append(1, '# -*- coding: utf-8 -*-')
  elseif ft=='sh'
    call setline(1, '#!/bin/bash')
  else
    call setline(1, '/**')
    call append(1, ' * File: ' . expand('%'))
    call append(2, ' * Author: wklken')
    call append(3, ' * Created: ' . strftime('%c'))
    call append(4, ' **/')
  endif
  normal G
endfunction

" 保存时自动删除行尾空白
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

"===============================================================================
" Theme Settings  主题设置
"===============================================================================
set background=dark t_Co=256
if has('gui_running')
  " set guifont=Monaco:h14
  set guioptions-=T  " 工具栏
  set guioptions+=e  " 菜单栏
  set guioptions-=rL " 去掉滚动条
  set guitablabel=%M\ %t
  set showtabline=1
  set linespace=2
  set noimd
endif

set guioptions+=b " 显示标签栏

colorscheme solarized
hi Normal ctermbg=none
hi Comment cterm=italic gui=italic
" hi Visual cterm=none ctermbg=8 ctermfg=0
hi QuickScopePrimary cterm=reverse gui=reverse
hi! link Visual QuickScopePrimary

hi! link SignColumn LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" for error highlight，防止错误整行标红导致看不清
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

" Todo/Debug 高亮
autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
autocmd Syntax * call matchadd('Debug','\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
