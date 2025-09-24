" Note with component_expand we need these autocmds to
" run to refesh the stattusline state. Otherwise, the
" components will become stale.
"
augroup vim_4_eva#statusline
  autocmd!
  " Note with lightline-ale we no longer need these autocmds.
  " This is since it already includes these.
  "
  "   autocmd User ALEJobStarted call lightline#update()
  "   autocmd User ALELintPost call lightline#update()
  "   autocmd User ALEFixPost call lightline#update()
  "
  " But we do need one for BufferWritePost to cover the case
  " when no linters exist for a given filetype.
  " TODO: consider moving this to a job queue with debouncing.
  " Same with the commands above ^^^.
  "
  autocmd BufWritePost * call lightline#update()
augroup END
