local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    {
      'plenary.nvim',
      lazy = true,
    },
    {
      'telescope.nvim',
      -- TODO: make this triggered by key stroke?
      event = 'DeferredUIEnter',
      before = function()
        require('lz.n').trigger_load('plenary.nvim')
      end,
    },
  })
end

return M
