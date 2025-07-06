set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Disables neovim python integration to speed up loading python files.
" Otherwise it takes forever to load these files.
"
" Alt option is to specify the python path. Eg:
"   let g:python3_host_prog = '/usr/bin/python3'
"
" Ref: https://neovim.io/doc/user/provider.html#g%3Apython3_host_prog
let g:loaded_python3_provider = 0

source ~/.vimrc

" Add neovim specific plugins here from vim/pack/{label}/opt.
" This is necessary to avoid autolaoding these in standard vim.
" Which would happen in the vim/pack/{label}/start directory.
packadd plenary.nvim
packadd telescope.nvim
