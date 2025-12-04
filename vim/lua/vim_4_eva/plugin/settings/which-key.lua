local M = {
  show_global = true,
}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'which-key.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('which-key').setup({
        preset = 'helix',
      })

      vim.keymap.set('n', '<leader>?', function()
        M.show_global = not M.show_global
        require('which-key').show({ global = M.show_global })
      end, { desc = 'Toggle Buffer Local Keymaps (which-key)' })
    end,
  })
end

return M
