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


