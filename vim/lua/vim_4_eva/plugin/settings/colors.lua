local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    {
      'lush.nvim',
      lazy = true,
      after = function()
        -- required for lush colorschemes to work
        vim.opt.termguicolors = true
      end,
    },
    {
      'zombat.nvim',
      colorscheme = 'zombat',
      before = function()
        require('lz.n').trigger_load('lush.nvim')
      end,
    },
  })
end

return M
