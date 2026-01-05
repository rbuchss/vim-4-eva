local M = {}

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
        -- Get layout configuration based on window size
        local function get_layout_config()
          local width = vim.o.columns
          if width > 200 then
            return {
              side = 'right',
              percentage = 0.35,
              is_vertical = true,
            }
          elseif width > 150 then
            return {
              side = 'right',
              percentage = 0.30,
              is_vertical = true,
            }
          else
            return {
              side = 'bottom',
              percentage = 0.35,
              is_vertical = false,
            }
          end
        end

        -- Initial layout configuration
        local layout = get_layout_config()

        require('claudecode').setup({
          terminal = {
            provider = 'auto',
            auto_close = true,
            split_side = layout.side,
            split_width_percentage = layout.percentage,
            cwd_provider = function(ctx)
              -- Prefer repo root; fallback to file's directory
              local cwd = (
                require('claudecode.cwd').git_root(ctx.file_dir or ctx.cwd)
                or ctx.file_dir or ctx.cwd
              )
              return cwd
            end,
          },
          diff_opts = {
            auto_close_on_accept = true,
            vertical_split = true,
            open_in_current_tab = false,
            keep_terminal_focus = false,
          },
          auto_start = true,
          log_level = 'info',
          track_selection = true,
          visual_demotion_delay_ms = 50,
        })

        -- Find Claude terminal window by checking for terminal buffers running claude
        local function find_claude_terminal_win()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local buftype = vim.bo[buf].buftype
            local bufname = vim.api.nvim_buf_get_name(buf)
            -- Terminal buffers have buftype 'terminal' and claude in the name
            if buftype == 'terminal' and bufname:match('claude') then
              return win
            end
          end
          return nil
        end

        -- Reposition the Claude terminal based on current width
        local function reposition_claude_terminal()
          local win = find_claude_terminal_win()
          if not win then
            return
          end

          local _layout = get_layout_config()
          local current_win = vim.api.nvim_get_current_win()

          vim.api.nvim_set_current_win(win)
          if _layout.is_vertical then
            -- Move to right side
            vim.cmd('wincmd L')
            vim.cmd('vertical resize ' .. math.floor(vim.o.columns * _layout.percentage))
          else
            -- Move to bottom
            vim.cmd('wincmd J')
            vim.cmd('resize ' .. math.floor(vim.o.lines * _layout.percentage))
          end
          vim.api.nvim_set_current_win(current_win)
        end

        -- Reposition on resize (debounced)
        local resize_timer = nil
        local augroup = vim.api.nvim_create_augroup('ClaudeCodeResize', { clear = true })

        vim.api.nvim_create_autocmd('VimResized', {
          group = augroup,
          callback = function()
            if resize_timer then
              vim.fn.timer_stop(resize_timer)
            end
            resize_timer = vim.fn.timer_start(200, function()
              vim.schedule(reposition_claude_terminal)
            end)
          end,
        })
      end,
    },
  })
end

return M
