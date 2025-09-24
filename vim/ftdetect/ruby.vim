augroup vim_4_eva#ftdetect#ruby
  autocmd!
  autocmd BufNewFile,BufRead *.rabl set filetype=ruby
  autocmd BufNewFile,BufRead *.pill set filetype=ruby
  autocmd BufNewFile,BufRead .simplecov set filetype=ruby
augroup END
