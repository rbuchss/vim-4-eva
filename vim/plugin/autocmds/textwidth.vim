" Put these in an autocmd group, so that we can delete them easily.
augroup vim_4_eva#plugin#textwidth
  autocmd!
  " For all files set 'textwidth' to 80 characters.
  "
  " TODO: make this only apply if textwidth is not already set.
  "
  autocmd FileType * setlocal textwidth=80
augroup END
