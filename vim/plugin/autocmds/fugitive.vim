augroup vim_4_eva#plugin#fugitive
  autocmd!
  autocmd User fugitive
        \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
        \  noremap <buffer> .. :edit %:h<cr> |
        \ endif
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
