
" plugins
call plug#begin('~/.vim/plugged')

" Atom One Dark / Light theme.
Plug 'joshdick/onedark.vim'

" Automatically show Vim's complete menu while typing.
Plug 'vim-scripts/AutoComplPop'

" light line styling
Plug 'itchyny/lightline.vim'

" Tcomment -> automatic comments
Plug 'tomtom/tcomment_vim'

" code formatting
Plug 'rhysd/vim-clang-format' " C/C++
Plug 'tell-k/vim-autopep8' " python

call plug#end()

" leader remapping
let leader = " "
let mapleader = " "

" easy save/quit mappings
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
nmap <leader>e :wq<CR>
imap <C-s> <C-o>:w<CR>

" easy jumping around beginning and end of files
nmap <C-a> <ESC>^
imap <C-a> <ESC>I
nmap <C-e> <ESC>$
imap <C-e> <ESC>A
cnoremap <C-A> <HOME>
cnoremap <C-E> <END>

" allow mouse. i use other gui applications and don't want to take my hand off the mouse when moving back
set mouse=a

" split options
nnoremap H <C-W>h
nnoremap L <C-W>l
nnoremap J <C-W>j
nnoremap K <C-W>k
set splitbelow splitright

" tab options
nnoremap <C-H> gT
nnoremap <C-L> gt
nnoremap <C-N> :tabnew<CR>

" source vimrc file
map <C-l> :source ~/.vimrc<CR>

" add numbers
set number
nmap <leader>nn :set invnumber<CR>

" easy jump into paste mode
nmap <leader>p :set invpaste<CR>

" run the previous command
noremap <C-p> :<UP><CR>

" i don't like automatic comments
nmap <C-x><C-m> :set formatoptions+=r<CR>
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Add semicolon to end of line
inoremap <leader>; <C-o>A;

" -------------------
" style related items
" -------------------
" enable syntax highlighting
syntax on

" use the atom one dark theme
colorscheme onedark

" tab related stuff
set tabstop=2
set shiftwidth=2

" ---------------------
" plugin customizations
" ---------------------

" lightline stuff
set noshowmode " don't show insert thing below lightline
set laststatus=2 " always show lightline
let g:lightline = { 'colorscheme': 'onedark' }

" tcommend -> leader is shift+/ or ?
let g:tcomment_mapleader1='?'

" clang-format
let g:clang_format#auto_format=1
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11"}

" autopep8
let g:autopep8_on_save = 1
let g:autopep8_disable_show_diff = 1

