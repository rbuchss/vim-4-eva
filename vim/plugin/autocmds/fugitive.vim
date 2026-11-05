augroup vim_4_eva#plugin#fugitive
  autocmd!
  autocmd User FugitiveTree,FugitiveBlob
        \ noremap <buffer> .. :edit %:h<cr>
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
