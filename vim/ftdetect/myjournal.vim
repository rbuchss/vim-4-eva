augroup vim_4_eva#ftdetect#myjournal
  autocmd!
  autocmd BufNewFile,BufRead *.myjournal set filetype=log.myjournal
  autocmd BufNewFile,BufRead TODO set filetype=log.myjournal
augroup END
