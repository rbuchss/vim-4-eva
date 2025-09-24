augroup vim_4_eva#ftdetect#shell
  autocmd!
  autocmd BufNewFile,BufRead *.bash set filetype=bash
  autocmd BufNewFile,BufRead *.bats set filetype=bash
augroup END
