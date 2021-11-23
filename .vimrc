" I'm a big fan of what I call 'psuedo-users'
" Try sourcing that users custom configurations
let user_vimrc = '$USER_HOME/.vimrc'
if !empty(glob(user_vimrc))
	so '$USER_HOME/.vimrc'
endif

" plugins
call plug#begin('~/.vim/plugged')

" Google code formatter
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'

" Atom One Dark / Light theme.
Plug 'joshdick/onedark.vim'

" light line styling
Plug 'itchyny/lightline.vim'

" CUDA syntax highlighting
Plug 'bfrg/vim-cuda-syntax'

" Tcomment -> automatic comments
Plug 'tomtom/tcomment_vim'

" code formatting
Plug 'rhysd/vim-clang-format' " C/C++
Plug 'tell-k/vim-autopep8' " python
Plug 'vim-scripts/json-formatter.vim' " json
Plug 'tikhomirov/vim-glsl'

" code autocomplete
" Plug 'ycm-core/YouCompleteMe'

" Automatically show Vim's complete menu while typing.
" Plug 'vim-scripts/AutoComplPop'

" NERDTree
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'

" abolish.vim
Plug 'tpope/vim-abolish'

" LaTeX
Plug 'vim-latex/vim-latex'

call plug#end()

" leader remapping
let leader = " "
let mapleader = " "

" easy save/quit mappings
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
" nmap <leader>e :wq<CR>
imap <C-s> <C-o>:w<CR>

" easy jumping around beginning and end of files
nmap <C-a> <ESC>^
imap <C-a> <ESC>I
nmap <C-e> <ESC>$
imap <C-e> <ESC>A
cnoremap <C-A> <HOME>
cnoremap <C-E> <END>

" allow mouse. I use other gui applications and don't want to take my hand off the mouse when moving back
set mouse=a

" split options
nnoremap H <C-w>h
nnoremap L <C-w>l
nnoremap J <C-w>j
nnoremap K <C-w>k
set splitbelow splitright

" tab options
nnoremap <C-h> gT
nnoremap <C-l> gt
nnoremap <C-n> :tabnew 

" source vimrc file
nnoremap <C-\> :source ~/.vimrc<CR>

" add numbers
set number
nnoremap <C-i> :set invnumber<CR>

" easy jump into paste mode
nmap <leader>p :set invpaste<CR>

" run the previous command
noremap <C-p> :<UP><CR>

" set cuda files to be seen as cpp files
autocmd BufEnter *.cu :setlocal filetype=cuda
autocmd BufEnter *.cuh :setlocal filetype=cuda

" automatic commenting
set formatoptions+=ro
function CommentStr() " Get the comment string
	return split(&comments, ':')[-1]
endfunction
function IsSoloComment() " Does the current line only have one comment?
	let comment = join(['^\s*', CommentStr(), '\s$'],'')
	return getline('.') =~ comment
endfunction
autocmd FileType python set comments=b:#,fb:-:# " Fix for python files
autocmd FileType json set comments=b:#,fb:-:# " Fix for json files
autocmd FileType cuda set comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,:// " Fix for cuda files
autocmd FileType python,cpp,cuda,c inoremap <expr> <enter> IsSoloComment() ? repeat('<bs>', strlen(CommentStr()) + 1) : '<enter>'

" Add semicolon to end of line
inoremap <leader>; <C-o>A;

" -------------------
" style related items
" -------------------
" enable syntax highlighting
syntax on

" use the atom one dark theme
silent! colorscheme onedark

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
autocmd FileType h,c,cc,cpp,cuda ClangFormatAutoEnable
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11"}

" autopep8
let g:autopep8_on_save = 0
let g:autopep8_disable_show_diff = 1
noremap <leader>[ :let g:autopep8_on_save = 0<CR>
noremap <leader>] :let g:autopep8_on_save = 1<CR>

" YouCompleteMe
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_complete_in_strings = 0
" let g:ycm_show_diagnostics_ui = 0
" let g:ycm_complete_in_comments = 0
" let g:ycm_always_populate_location_list = 1

" NERDTree
nnoremap <leader>n :NERDTreeTabsToggle<CR>

" SWIG Syntax Highlighting
au BufNewFile,BufRead *.i set filetype=swig
au BufNewFile,BufRead *.swg set filetype=swig

" vim-codefmt
augroup autoformat_settings
	autocmd FileType javascript AutoFormatBuffer prettier
	autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
augroup END
