" ================ Plugin Config ====================
" https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'fatih/vim-go'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'aonemd/kuroi.vim'
Plug 'tpope/vim-sensible'
Plug 'christoomey/vim-tmux-navigator'
Plug 'gabrielelana/vim-markdown'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'google/vim-jsonnet'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } |
  \ Plug 'Xuyuanp/nerdtree-git-plugin'


Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
call plug#end()
set background=dark
silent! colorscheme gruvbox

set path=$PWD/**
"
" ================ Markdown Config ====================

" Map C-n to view navigation items
" <bar> command separator http://vim.wikia.com/wiki/Multiple_commands_at_once
" :g/^#\+ /# https://vimrcfu.com/snippet/165
autocmd FileType markdown map <buffer> <C-n> :g/^#\+ /# <bar> :nohl <Enter>

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set noshowmode
set relativenumber

" Can haz ability to escape terminal easily plz?
tnoremap <ESC> <C-w>:q!<CR>

nnoremap gb :ls<CR>:b<Space>

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

au BufNewFile,BufRead *.libsonnet
    \ nnoremap <buffer> <leader>r :CustomPreview("jsonnet --jpath vendor")<cr>

au BufNewFile,BufRead *.go
    \ nnoremap <buffer> <leader>r :GoRun<cr>

highlight ExtraWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
    \ match ExtraWhitespace /\s\+$/

set encoding=UTF-8
let python_highlight_all=1
let mapleader = " "
let g:ctrlp_extensions = ['tag']
let g:ctrlp_cmd = 'CtrlPMixed'
" let g:gutentags_ctags_executable_go = 'gotags'
" let g:gutentags_ctags_exclude=["vendor"]
" let g:lightline = {
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'readonly', 'filename', 'modified', 'gutentags' ] ]
"       \ },
"       \ 'component': {
"       \   'gutentags': '%{gutentags#statusline()}',
"       \ },
"       \ }
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

nnoremap <leader>f :FZF<CR>
nnoremap <leader>e :e<SPACE>
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>a :Ag<CR>
nnoremap <leader>. :CtrlPTag<CR>
map <leader>n :NERDTreeToggle<CR>
map <leader>o :NERDTreeToggle %<CR>
nmap <leader>T :TagbarToggle<CR>
map <leader>t :tabnew<CR>
map <leader>c :tabclose<CR>
nnoremap <leader>h :tabprevious<CR>
nnoremap <leader>l gt

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ 'Modified'  :'✹',
  \ 'Staged'    :'✚',
  \ 'Untracked' :'✭',
  \ 'Renamed'   :'➜',
  \ 'Unmerged'  :'═',
  \ 'Deleted'   :'✖',
  \ 'Dirty'     :'✗',
  \ 'Ignored'   :'☒',
  \ 'Clean'     :'✔︎',
  \ 'Unknown'   :'?',
  \ }

" This should probably be refactored... I am new to VimScript
fun! CustomPreview(cmd)
    set splitright
    let file_name = expand('%:p')
    silent! exe "noautocmd vertical pedit ".a:cmd." ".file_name
    noautocmd wincmd P
    set buftype=nofile
    exe "noautocmd r! ".a:cmd." ".file_name
    vertical resize 60
    set filetype=json
    noautocmd wincmd p
    set nosplitright
endfun

com -nargs=1 CustomPreview call CustomPreview(<args>)
autocmd VimEnter * TagbarToggle
