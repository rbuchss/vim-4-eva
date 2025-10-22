local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    {
      'nvim-nio',
      lazy = true,
    },
    {
      'nvim-dap-ui',
      lazy = true,
      before = function()
        require('lz.n').trigger_load('nvim-nio')
      end,
    },
    {
      'mason-nvim-dap.nvim',
      lazy = true,
      before = function()
        require('lz.n').trigger_load('mason.nvim')
      end,
    },
    {
      'nvim-dap',
      keys = {
        {
          '<F5>',
          function()
            require('dap').continue()
          end,
          desc = 'Debug: Start/Continue',
          mode = 'n',
        },
        {
          '<F1>',
          function()
            require('dap').step_into()
          end,
          desc = 'Debug: Step Into',
          mode = 'n',
        },
        {
          '<F2>',
          function()
            require('dap').step_over()
          end,
          desc = 'Debug: Step Over',
          mode = 'n',
        },
        {
          '<F3>',
          function()
            require('dap').step_out()
          end,
          desc = 'Debug: Step Out',
          mode = 'n',
        },
        {
          '<leader>b',
          function()
            require('dap').toggle_breakpoint()
          end,
          desc = 'Debug: Toggle Breakpoint',
          mode = 'n',
        },
        {
          '<leader>B',
          function()
            require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
          end,
          desc = 'Debug: Set Breakpoint',
          mode = 'n',
        },
        {
          '<F7>',
          function()
            require('dapui').toggle()
          end,
          desc = 'Debug: See last session result.',
          mode = 'n',
        },
      },
      before = function()
        require('lz.n').trigger_load({
          'nvim-dap-ui',
          'mason-nvim-dap.nvim',
        })
      end,
      after = function()
        local dap = require('dap')
        local dapui = require('dapui')

        require('mason-nvim-dap').setup {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = false,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        }

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup {
          -- Set icons to characters that are more likely to work in every terminal.
          --    Feel free to remove or use ones that you like more! :)
          --    Don't feel like these are good choices.
          icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
          controls = {
            icons = {
              pause = '⏸',
              play = '▶',
              step_into = '⏎',
              step_over = '⏭',
              step_out = '⏮',
              step_back = 'b',
              run_last = '▶▶',
              terminate = '⏹',
              disconnect = '⏏',
            },
          },
        }

        -- Change breakpoint icons
        vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
        vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })

        local breakpoint_icons = {
          Breakpoint = '',
          BreakpointCondition = '⊜',
          BreakpointRejected = '⊘',
          LogPoint = '',
          Stopped = '',
        }

        for type, icon in pairs(breakpoint_icons) do
          local tp = 'Dap' .. type
          local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
          vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        end

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
      end,
    },
  })
end

return M
