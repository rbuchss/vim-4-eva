local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'fidget.nvim',
    lazy = true,
    after = function()
      require('fidget').setup({})
    end,
  })
end

return M
