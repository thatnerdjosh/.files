call plug#begin()
  Plug 'fatih/vim-go'
  Plug 'morhetz/gruvbox'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tpope/vim-sensible'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'gabrielelana/vim-markdown'
  Plug 'majutsushi/tagbar'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'vim-syntastic/syntastic'
  Plug 'google/vim-jsonnet'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'scrooloose/nerdtree'
call plug#end()

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

set background=dark
colorscheme gruvbox
