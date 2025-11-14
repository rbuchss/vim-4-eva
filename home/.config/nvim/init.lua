-- Set runtime path to include ~/.vim directories
vim.opt.runtimepath:prepend('~/.vim')
vim.opt.runtimepath:append('~/.vim/after')

-- Set packpath to match runtimepath
vim.opt.packpath = vim.opt.runtimepath:get()

-- Source the existing vimrc file
vim.cmd.source('~/.vimrc')

require('vim_4_eva.profile').setup({})
