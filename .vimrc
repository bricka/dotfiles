function! s:is_node()
    return !empty(findfile("package.json", ".;"))
endfunction

function! s:is_maven()
    return !empty(findfile("pom.xml", ".;"))
endfunction

" Vundle

let $GIT_SSL_NO_VERIFY = 'true'

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'mikelue/vim-maven-plugin'
Plugin 'elzr/vim-json'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'JalaiAmitahl/maven-compiler.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'rking/ag.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'marijnh/tern_for_vim'
Plugin 'groenewege/vim-less'
Plugin 'moll/vim-node'
Plugin 'chriskempson/base16-vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'ap/vim-css-color'
Plugin 'mtscout6/syntastic-local-eslint.vim'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'schickling/vim-bufonly'

call vundle#end()

let mapleader = ','

" Configuration for airline

let g:airline_theme='base16_default'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#show_close_button = 0

" Configuration for syntastic

let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list = 1

let g:syntastic_pom_checkers = ['xmllint']
au FileType javascript.jsx let b:syntastic_checkers = ['eslint']
au FileType javascript let b:syntastic_checkers = ['eslint']

" Configuration for ctrlp

let g:ctrlp_by_filename = 1

function! s:calculate_custom_ignore()
    if s:is_node() && !empty(finddir("lib")) && !empty(finddir("src"))
        " This is a node package where we compile src/ into lib/
        let g:ctrlp_custom_ignore = {
            \ 'dir': 'lib',
            \ }
    elseif s:is_maven()
        let g:ctrlp_custom_ignore = {
            \ 'dir': 'target',
            \ }
    endif
endfunction

exec s:calculate_custom_ignore()

au BufNewFile,BufRead */porch-all/* let b:ctrlp_root_markers = ['pom.xml']

" Configuration for tagbar

autocmd FileType,BufEnter scala,java nested :call tagbar#autoopen(0)

" Configuration for vim-json

let g:vim_json_syntax_conceal = 0

" Configuration for vim-jsx

let g:jsx_ext_required = 0

" Configuration for YouCompleteMe

let g:ycm_autoclose_preview_window_after_completion = 1

" Configuration for vim-markdown-preview

let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_browser='Firefox'

" Normal vimrc
syntax on
set autoindent
set shiftwidth=4
set tabstop=4
set showmatch
set matchtime=2
set background=dark
set noerrorbells
set expandtab
set hlsearch
set printoptions=left:8pc,syntax:a,number:y,wrap:y,paper:letter
set wildmode=longest:full
set wildmenu
set display=uhex
set formatoptions-=l
set foldmethod=manual
set foldcolumn=1
set laststatus=2
set number
set hidden

set wildignore+=*.class
set wildignore+=*/dist/*
'
let base16colorspace=256
colorscheme base16-default-dark
set bg=dark

nnoremap gt :bnext<cr>
nnoremap gT :bprev<cr>
nnoremap gn :e<space>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>z :tab split<cr>

inoremap # X<bs>#

command! Mc Make compile

au BufRead,BufNewFile *.c	set cindent
au BufRead,BufNewFile *.mips set syntax=mips

command Spell setlocal spell spelllang=en_us
command NoSpell set nospell

filetype plugin indent on

runtime ftplugin/man.vim
runtime macros/matchit.vim

" Additional filetypes

au BufRead,BufNewFile .babelrc set ft=json
au BufRead,BufNewFile .eslintrc set ft=json
