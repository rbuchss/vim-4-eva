"-----------------------------------------------------------------------------
" eval vimscript by line or visual selection
"-----------------------------------------------------------------------------
nmap <silent> <leader>ve :call Source(line('.'), line('.'))<CR>
vmap <silent> <leader>ve :call Source(line('v'), line('.'))<CR>

function! Source(begin, end)
  let lines = getline(a:begin, a:end)
  for line in lines
    execute line
  endfor
endfunction
