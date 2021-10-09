let g:config_files = ['general.vim',
      \ 'filetypes.vim',
      \ 'plugins.vim',
      \ 'commands.vim',
      \ ]

let g:vim_config_root = expand('<sfile>:p:h')
for s:file in g:config_files
  execute printf('source %s/%s', g:vim_config_root, s:file)
endfor

" NeoViM specific config
if has("nvim")
endif
