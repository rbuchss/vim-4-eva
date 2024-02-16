" let g:netrw_winsize = 15
let g:netrw_altv = 1
" let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

" Tree view is broken for neovim so disable it if using neovim
if !has('nvim')
  let g:netrw_liststyle = 3
endif
