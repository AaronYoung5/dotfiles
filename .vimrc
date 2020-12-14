let leader = " "
let mapleader = " "

call plug#begin('~/.vim/plugged')

Plug 'https://github.com/flazz/vim-colorschemes.git'
Plug 'https://github.com/jiangmiao/auto-pairs'
Plug 'https://github.com/itchyny/lightline.vim'
Plug 'tomtom/tcomment_vim'

call plug#end()

set number number
syntax on

set splitbelow splitright

map <leader>w :w<CR>
map <leader>q :q<CR>
map <leader>e :wq<CR>

silent! colorscheme Monokai
set laststatus=2
set noshowmode
let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ }

let g:tcomment_mapleader1='?'

" Don't like automatic comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
