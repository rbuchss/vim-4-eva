local M = {}

function M.setup(config)
  -- required for lush colorschemes to work
  vim.opt.termguicolors = true

  vim.cmd.colorscheme 'zombat'
end

return M
