augroup vim_4_eva#plugin#spell
  autocmd!
  " only auto enable spelling for these few types
  autocmd FileType svn,*commit* setlocal spell
  autocmd FileType help setlocal nospell
augroup END
