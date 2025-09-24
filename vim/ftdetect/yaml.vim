augroup vim_4_eva#ftdetect#yaml
  autocmd!
  autocmd BufNewFile,BufRead *.reek set filetype=yaml
  autocmd BufNewFile,BufRead *.clang-tidy set filetype=yaml
augroup END
