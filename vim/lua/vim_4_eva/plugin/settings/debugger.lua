local M = {
  loaded = {},
}

M.filetype_callbacks = {
  any = function()
    if M.loaded['nvim-dap'] then
      return
    end

    require('lz.n').trigger_load('nvim-dap')
    M.loaded['nvim-dap'] = true
  end,
  python = function()
    if M.loaded['nvim-dap-python'] then
      return
    end

    require('lz.n').trigger_load('nvim-dap-python')
    M.loaded['nvim-dap-python'] = true
  end,
}

function M.setup(_)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'

    local wrapped_func = function()
      M.filetype_callbacks.any()

      local filetype_callback = M.filetype_callbacks[vim.bo.filetype]

      if filetype_callback then
        filetype_callback()
      end

      -- Add a small delay to ensure plugins are loaded before calling DAP
      vim.schedule(func)
    end

    if type(keys) == 'string' then
      keys = { keys }
    end

    for _, key in ipairs(keys) do
      vim.keymap.set(mode, key, wrapped_func, { desc = 'Debug: ' .. desc })
    end
  end

  map(
    {'<leader>dc', '<F5>'},
    function()
      require('dap').continue()
    end,
    'Run/Continue'
  )

  map(
    {'<leader>dC', '<S-F5>'},
    function()
      require('dap').run_last()
    end,
    'Run Last'
  )

  map(
    {'<leader>dT', '<C-F5>'},
    function()
      require('dap').terminate()
    end,
    'Terminate'
  )

  map(
    {'<leader>dR', '<M-F5>'},
    function()
      require('dap').restart()
    end,
    'Restart'
  )

  map(
    {'<leader>dur', '<F8>'},
    function()
      require('dap').repl.toggle()
    end,
    'REPL Toggle'
  )

  map(
    {'<leader>dui', '<S-F8>'},
    function()
      require('dapui').toggle()
    end,
    'UI Toggle'
  )

  map(
    {'<leader>db', '<F9>'},
    function()
      require('dap').toggle_breakpoint()
    end,
    'Toggle Breakpoint'
  )

  map(
    {'<leader>dB', '<S-F9>'},
    function()
      require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end,
    'Set Breakpoint'
  )

  map(
    {'<leader>dl', '<C-F9>'},
    function()
      require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end,
    'Set Log Point Breakpoint'
  )

  map(
    {'<leader>do', '<F10>'},
    function()
      require('dap').step_over()
    end,
    'Step Over'
  )

  map(
    {'<leader>di', '<F11>'},
    function()
      require('dap').step_into()
    end,
    'Step Into'
  )

  map(
    {'<leader>dO', '<F12>'},
    function()
      require('dap').step_out()
    end,
    'Step Out'
  )

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
      -- NOTE: that we keep this as lazy = true without any keys or load events
      -- registered. This allows us to allow for AND configurations for events
      -- to be used for common keys across language specific debuggers.
      -- See the wrapped_func callbacks logic above.
      lazy = true,
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
            'debugpy',
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
    {
      'nvim-dap-python',
      lazy = true,
      after = function()
        local function find_python_path()
          -- Try uv first if it exists and project uses uv
          if vim.fn.executable('uv') == 1 then
            -- Check if current project has uv.lock or pyproject.toml with uv config
            local has_uv_lock = vim.fn.filereadable('uv.lock') == 1
            local has_pyproject = vim.fn.filereadable('pyproject.toml') == 1

            if has_uv_lock or has_pyproject then
              -- uv can handle virtual environment detection automatically
              return 'uv'
            end
          end

          -- Fallback to project .venv
          local venv_patterns = {
            '.venv/bin/python',
            'venv/bin/python',
            '.venv/Scripts/python.exe', -- Windows
            'venv/Scripts/python.exe',  -- Windows
          }

          for _, pattern in ipairs(venv_patterns) do
            local venv_path = vim.fn.getcwd() .. '/' .. pattern
            if vim.fn.filereadable(venv_path) == 1 then
              return venv_path
            end
          end

          -- Final fallback to system python
          if vim.fn.executable('python3') == 1 then
            return vim.fn.exepath('python3')
          elseif vim.fn.executable('python') == 1 then
            return vim.fn.exepath('python')
          end

          -- Last resort: use pyenv shims if nothing else works
          return '/Users/russ/.pyenv/shims/python'
        end

        require('dap-python').setup(find_python_path())
      end,
    },
  })
end

return M
