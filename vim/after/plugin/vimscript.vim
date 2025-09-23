"-----------------------------------------------------------------------------
" eval vimscript by line or visual selection
"-----------------------------------------------------------------------------
nmap <silent> <leader>ve
      \ :call vim_4_eva#vimscript#Source(line('.'), line('.'))<CR>

vmap <silent> <leader>ve
      \ :call vim_4_eva#vimscript#Source(line('v'), line('.'))<CR>
