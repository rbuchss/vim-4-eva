" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  autocmd!
  " For all files set 'textwidth' to 80 characters.
  autocmd FileType * setlocal textwidth=80
augroup END
