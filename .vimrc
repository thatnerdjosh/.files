" ================ Plugin Config ====================
" https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'arcticicestudio/nord-vim'
Plug 'sbdchd/neoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'gabrielelana/vim-markdown'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/indentpython.vim'
Plug 'mileszs/ack.vim'
Plug 'ludovicchabant/vim-gutentags'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocompleter' }
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-fugitive'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

"Plug 'fatih/vim-go', { 'tag': '*' }
"Plug 'nsf/gocode', { 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'itchyny/lightline.vim'
call plug#end()
silent! colorscheme nord

set path=$PWD/**
"
" ================ Markdown Config ====================

" Map C-n to view navigation items
" <bar> command separator http://vim.wikia.com/wiki/Multiple_commands_at_once
" :g/^#\+ /# https://vimrcfu.com/snippet/165
autocmd FileType markdown map <buffer> <C-n> :g/^#\+ /# <bar> :nohl <Enter>

let g:lightline = {
  \ 'colorscheme': 'nord',
\ }

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set noshowmode
set relativenumber

nnoremap gb :ls<CR>:b<Space>

augroup PHP
  autocmd!

  " Check for PHP syntax errors after saving a file
  autocmd BufWritePost {*.php} echom system("~/php-wrapper.sh -l ".expand('%'))
augroup END

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ nnoremap <buffer> <leader>r :exec '!python' shellescape(@%, 1)<cr>

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

au BufNewFile,BufRead *.go
    \ nnoremap <buffer> <leader>r :GoRun<cr>

highlight ExtraWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
    \ match ExtraWhitespace /\s\+$/

set encoding=utf-8
let python_highlight_all=1
let g:ycm_autoclose_preview_window_after_completion=1
let mapleader = ","
let g:ctrlp_extensions = ['tag']

map <leader>n :NERDTreeToggle<CR>
map <leader>t :tabnew<CR>
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> gt
nnoremap <Leader>a :Ack!<Space>

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
