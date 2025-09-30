-- Set runtime path to include ~/vimfiles directories (Windows paths)
vim.opt.runtimepath:prepend("~/vimfiles")
vim.opt.runtimepath:append("~/vimfiles/after")

-- Set packpath to match runtimepath
vim.opt.packpath = vim.opt.runtimepath:get()

-- Source the existing vimrc file (Windows path)
vim.cmd.source('~/_vimrc')

require('vim_4_eva.pack').setup({
  packages = 'all',
})

require('vim_4_eva.plugin').setup({})
require('vim_4_eva.ftplugin').setup({})
