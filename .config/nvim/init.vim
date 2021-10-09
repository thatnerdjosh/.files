let g:config_files = ['general.vim',
      \ 'filetypes.vim',
      \ 'plugins.vim',
      \ 'commands.vim',
      \ ]

for s:file in g:config_files
  execute printf('source ~/.vim/%s', s:file)
endfor

" NeoViM specific config
if has("nvim")
endif
