local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'which-key.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('which-key').setup({})

      vim.keymap.set('n', '<leader>?', function()
        require('which-key').show({ global = false })
      end, { desc = 'Buffer Local Keymaps (which-key)' })
    end,
  })
end

return M
