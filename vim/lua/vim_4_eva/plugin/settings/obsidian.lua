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
            date_format = '%Y/%m/%d',
            default_tags = {
              'daily-notes',
            },
            workdays_only = false,
          },
          frontmatter = {
            func = function(note)
              -- Check if this is a daily note by looking at the path
              local path_str = tostring(note.path)
              if path_str:match('Journal/(%d%d%d%d)/(%d%d)/(%d%d)%.md') then
                -- Extract date from path and set as ID
                local year, month, day = path_str:match('Journal/(%d%d%d%d)/(%d%d)/(%d%d)%.md')
                note.id = year .. '-' .. month .. '-' .. day
              end

              -- Add extra tags from environment variable (CSV format)
              local extra_tags = os.getenv('OBSIDIAN_DAILY_NOTE_EXTRA_TAGS')
              if extra_tags then
                for tag in extra_tags:gmatch('[^,]+') do
                  note:add_tag(tag:match('^%s*(.-)%s*$'))  -- trim whitespace
                end
              end

              return require('obsidian.builtin').frontmatter(note)
            end,
          },
          ui = {
            enable = true,
          },
        }
      )
    end,
  })
end

return M
