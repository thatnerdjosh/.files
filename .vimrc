" ================ Plugin Config ====================
" https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard'
Plug 'sbdchd/neoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ludovicchabant/vim-gutentags'
Plug 'gabrielelana/vim-markdown'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocompleter' }
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-fugitive'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'nsf/gocode', { 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'itchyny/lightline.vim'
call plug#end()
colo seoul256

" ================ Markdown Config ====================

" Map C-n to view navigation items
" <bar> command separator http://vim.wikia.com/wiki/Multiple_commands_at_once
" :g/^#\+ /# https://vimrcfu.com/snippet/165
autocmd FileType markdown map <buffer> <C-n> :g/^#\+ /# <bar> :nohl <Enter>

let g:lightline = {
  \ 'colorscheme': 'seoul256',
\ }

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set noshowmode
set relativenumber

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nnoremap gb :ls<CR>:b<Space>

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h 
"    \ match Cursor /\s\+$/
set encoding=utf-8
let python_highlight_all=1
let g:ycm_autoclose_preview_window_after_completion=1
let mapleader = ","
map <leader>n :NERDTreeToggle<CR>
map <leader>t :TagbarToggle<CR>
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
