local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'todo-comments.nvim',
    event = 'DeferredUIEnter',
    after = function()
      require('todo-comments').setup({})

      vim.keymap.set('n', ']t', function()
        require('todo-comments').jump_next()
      end, { desc = 'Next todo comment' })

      vim.keymap.set('n', '[t', function()
        require('todo-comments').jump_prev()
      end, { desc = 'Previous todo comment' })
    end,
  })
end

return M
