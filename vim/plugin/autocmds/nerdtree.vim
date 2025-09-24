augroup vim_4_eva#plugin#nerdtree
  autocmd!
  autocmd BufEnter * if (
        \   winnr("$") == 1
        \   && exists("b:NERDTreeType")
        \   && b:NERDTreeType == "primary"
        \ ) | q | endif
augroup END
