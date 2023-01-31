set nocompatible

call plug#begin()
Plug 'sheerun/vimrc'
Plug 'sheerun/vim-polyglot'
#Plug 'arcticicestudio/nord-vim', 
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'Yggdroot/indentLine'
call plug#end()

#let g:lightline = {
#	\ 'colorscheme': 'nord',
#	\ }

# colorscheme nord

let g:indentLine_enabled = 0
let g:indentLine_char = '|'

let g:NERDSpaceDelims = 1
map <C-n> :NERDTreeToggle<CR>

set ignorecase
set smartcase
set hlsearch
set incsearch
