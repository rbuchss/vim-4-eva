-- Set runtime path to include ~/.vim directories
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")

-- Set packpath to match runtimepath
vim.opt.packpath = vim.opt.runtimepath:get()

-- Source the existing vimrc file
vim.cmd.source('~/.vimrc')

require('vim_4_eva.pack').setup({
  -- Add neovim specific plugins here from vim/pack/{label}/opt.
  -- This is necessary to avoid autolaoding these in standard vim.
  -- Which would happen in the vim/pack/{label}/start directory.
  'plenary.nvim',
  'telescope.nvim',
  'nvim-treesitter',
  'mason.nvim',
  'mason-lspconfig.nvim',
  'mason-tool-installer.nvim',
  'nvim-lspconfig',
  'fidget.nvim',
  'blink.cmp',
  'lush.nvim',
  'windsurf.nvim',
  'gitsigns.nvim',
  'statuscol.nvim',
})

require('vim_4_eva.plugin').setup({})
