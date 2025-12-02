local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'obsidian.nvim',
    -- Only load obsidian.nvim for markdown files in vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. 'BufReadPre ' .. vim.fn.expand '~' .. '/my-vault/*.md'
      -- refer to `:h file-pattern` for mo examples
      'BufReadPre ' .. vim.fn.expand('~') .. '/vaults/chronicle/*.md',
      'BufNewFile ' .. vim.fn.expand('~') .. '/vaults/chronicle/*.md',
    },
    cmd = {
      'Obsidian',
    },
    before = function()
      require('lz.n').trigger_load('telescope.nvim')
    end,
    after = function()
      require('obsidian').setup(
        ---@module 'obsidian'
        ---@type obsidian.config
        {
          legacy_commands = false, -- this will be removed in the next major release
          workspaces = {
            {
              name = 'chronicle',
              path = '~/vaults/chronicle',
            },
          },
          daily_notes = {
            folder = 'Journal',
            default_tags = {
              'Journal',
              'daily-notes',
            },
            workdays_only = false,
          },
        }
      )
    end,
  })
end

return M
