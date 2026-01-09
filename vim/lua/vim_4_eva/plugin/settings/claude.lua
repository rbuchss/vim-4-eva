local M = {}

--- Notify helper that prefers fidget.notify if available
--- @param msg string The notification message
--- @param level number The log level (vim.log.levels.*)
--- @param opts table? Optional notification options
local function notify(msg, level, opts)
  local ok, fidget = pcall(require, 'fidget')

  if ok and fidget.notify then
    fidget.notify(msg, level, opts)
  else
    vim.notify(msg, level, opts)
  end
end

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    -- snacks.nvim - dependency for claudecode.nvim
    {
      'snacks.nvim',
      lazy = true,
      after = function()
        require('snacks').setup({
          -- Terminal configuration
          terminal = {
            win = { style = 'terminal' },
          },
          -- Enable only the features we need
          bigfile = { enabled = false },
          notifier = { enabled = false },
          quickfile = { enabled = false },
          statuscolumn = { enabled = false },
          words = { enabled = false },
          styles = {
            terminal = {
              bo = {
                filetype = 'snacks_terminal',
              },
              wo = {},
            },
          },
        })
      end,
    },
    {
      'claudecode.nvim',
      cmd = {
        'ClaudeCode',
        'ClaudeCodeFocus',
        'ClaudeCodeSelectModel',
        'ClaudeCodeAdd',
        'ClaudeCodeSend',
        'ClaudeCodeTreeAdd',
        'ClaudeCodeDiffAccept',
        'ClaudeCodeDiffDeny',
        'ClaudeCodeStatus',
      },
      keys = {
        {
          '<leader>ac',
          '<cmd>ClaudeCodeFocus<cr>',
          desc = 'Claude Code: Toggle',
          mode = { 'n', 'x' },
        },
        {
          '<leader>aC',
          '<cmd>ClaudeCode --continue<cr>',
          desc = 'Claude Code: Continue',
          mode = 'n',
        },
        {
          '<leader>ar',
          '<cmd>ClaudeCode --resume<cr>',
          desc = 'Claude Code: Resume',
          mode = 'n',
        },
        {
          '<leader>am',
          '<cmd>ClaudeCodeSelectModel<cr>',
          desc = 'Claude Code: Select Model',
          mode = 'n',
        },
        {
          '<leader>ab',
          '<cmd>ClaudeCodeAdd %<cr>',
          desc = 'Claude Code: Add Buffer',
          mode = 'n',
        },
        {
          '<leader>as',
          '<cmd>ClaudeCodeSend<cr>',
          desc = 'Claude Code: Send Selection',
          mode = 'v',
        },
        {
          '<leader>aa',
          '<cmd>ClaudeCodeDiffAccept<cr>',
          desc = 'Claude Code: Accept Diff',
          mode = 'n',
        },
        {
          '<leader>ad',
          '<cmd>ClaudeCodeDiffDeny<cr>',
          desc = 'Claude Code: Deny Diff',
          mode = 'n',
        },
      },
      before = function()
        -- Dependency on snacks.nvim for window management
        require('lz.n').trigger_load('snacks.nvim')
      end,
      after = function()
        -- Get layout configuration based on terminal size
        -- Uses nvim_list_uis() to get actual terminal dimensions, which is more
        -- reliable than vim.o.columns during window transitions
        local function get_layout_config()
          local uis = vim.api.nvim_list_uis()
          local width = uis[1] and uis[1].width or vim.o.columns

          if width > 285 then
            return { position = 'right', width = 0.35, height = 1.0 }
          elseif width > 215 then
            return { position = 'right', width = 0.30, height = 1.0 }
          else
            return { position = 'bottom', width = 1.0, height = 0.35 }
          end
        end

        -- Initial layout configuration
        local layout = get_layout_config()

        require('claudecode').setup({
          terminal = {
            provider = 'snacks',
            auto_close = true,
            snacks_win_opts = layout,
            cwd_provider = function(ctx)
              -- Prefer repo root; fallback to file's directory
              local cwd = (
                require('claudecode.cwd').git_root(ctx.file_dir or ctx.cwd)
                or ctx.file_dir or ctx.cwd
              )

              notify(
                string.format('claudecode cwd: %s', cwd),
                vim.log.levels.INFO,
                { title = 'claudecode.nvim' }
              )

              return cwd
            end,
          },
          diff_opts = {
            auto_close_on_accept = true,
            vertical_split = true,
            open_in_current_tab = false,
            keep_terminal_focus = true,
          },
          auto_start = true,
          log_level = 'info',
          track_selection = true,
          visual_demotion_delay_ms = 50,
        })

        -- Find Claude terminal windows, optionally filtered by tabpage
        local function find_claude_terminal_wins(tabpage)
          local wins = {}
          local win_list = tabpage
              and vim.api.nvim_tabpage_list_wins(tabpage)
              or vim.api.nvim_list_wins()

          for _, win in ipairs(win_list) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buftype = vim.bo[buf].buftype
            local bufname = vim.api.nvim_buf_get_name(buf)
            -- Terminal buffers have buftype 'terminal' and claude in the name
            if buftype == 'terminal' and bufname:match('claude') then
              table.insert(wins, win)
            end
          end
          return wins
        end

        -- Reposition terminal windows based on current layout config
        -- If tabpage is provided, only reposition terminals in that tab
        local function reposition_terminals(tabpage)
          local wins = find_claude_terminal_wins(tabpage)
          if #wins == 0 then
            return
          end

          local _layout = get_layout_config()
          local current_win = vim.api.nvim_get_current_win()

          for _, win in ipairs(wins) do
            vim.api.nvim_set_current_win(win)
            if _layout.position == 'right' or _layout.position == 'left' then
              vim.cmd('wincmd ' .. (_layout.position == 'right' and 'L' or 'H'))
              vim.cmd('vertical resize ' .. math.floor(vim.o.columns * _layout.width))
            else
              vim.cmd('wincmd ' .. (_layout.position == 'bottom' and 'J' or 'K'))
              vim.cmd('resize ' .. math.floor(vim.o.lines * _layout.height))
            end
          end

          vim.api.nvim_set_current_win(current_win)
        end

        -- Update layout on resize (debounced)
        local resize_timer = nil
        local augroup = vim.api.nvim_create_augroup('ClaudeCodeResize', { clear = true })

        vim.api.nvim_create_autocmd('VimResized', {
          group = augroup,
          callback = function()
            if resize_timer then
              vim.fn.timer_stop(resize_timer)
            end
            resize_timer = vim.fn.timer_start(200, function()
              vim.schedule(reposition_terminals)
            end)
          end,
        })

        -- Manual reposition command
        vim.api.nvim_create_user_command('ClaudeCodeReposition', function()
          reposition_terminals()
        end, { desc = 'Reposition Claude terminal windows based on current layout' })

        -- Reposition terminal when entering a tab (handles new diff tabs)
        vim.api.nvim_create_autocmd('TabEnter', {
          group = augroup,
          callback = function()
            local tabpage = vim.api.nvim_get_current_tabpage()
            -- Defer to let the tab fully initialize
            vim.defer_fn(function()
              -- Guard against tab closing before defer fires
              if vim.api.nvim_tabpage_is_valid(tabpage) then
                reposition_terminals(tabpage)
              end
            end, 50)
          end,
        })
      end,
    },
  })
end

return M
