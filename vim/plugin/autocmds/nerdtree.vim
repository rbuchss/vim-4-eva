augroup vim_4_eva#plugin#nerdtree
  autocmd!
  autocmd BufEnter * if (
        \   winnr("$") == 1
        \   && exists("b:NERDTree")
        \   && b:NERDTree.isTabTree()
        \ ) | call feedkeys(":quit\<CR>:\<BS>") | endif
augroup END
