" ================ Plugin Config ====================
" https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/neosnippet-snippets'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'aonemd/kuroi.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'tpope/vim-sensible'
Plug 'christoomey/vim-tmux-navigator'
Plug 'gabrielelana/vim-markdown'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'nsf/gocode', { 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'itchyny/lightline.vim'
call plug#end()
set background=dark
silent! colorscheme kuroi

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

au BufNewFile,BufRead *.go
    \ nnoremap <buffer> <leader>r :GoRun<cr>

highlight ExtraWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h
    \ match ExtraWhitespace /\s\+$/

set encoding=utf-8
let python_highlight_all=1
let mapleader = ","
let g:ctrlp_extensions = ['tag']
let g:ctrlp_cmd = 'CtrlPMixed'
nmap <F8> :TagbarToggle<CR>
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
let g:go_snippet_engine = "neosnippet"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

nnoremap <leader>. :CtrlPTag<cr>
map <leader>n :NERDTreeToggle<CR>
map <leader>t :tabnew<CR>
nnoremap <leader>h :tabprevious<CR>
nnoremap <leader>l gt
nnoremap <Leader>a :Ack!<Space>

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
