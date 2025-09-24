" neovim removed support for pastetoggle
" so don't load this unless running in normal vim
if !has('nvim')
    set pastetoggle=<leader>pt
endif
