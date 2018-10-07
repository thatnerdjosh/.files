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

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
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

map <C-n> :NERDTreeToggle<CR>
let g:lightline = {
  \ 'colorscheme': 'seoul256',
\ }

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set noshowmode

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
