local M = {
  loaded = {},
  current_layouts = {},
  -- Common layout parameters for individual element layouts
  single_element_size = 20,
  single_element_position = 'bottom',
}

function M.notify(message, level)
  level = level or vim.log.levels.WARN
  local opts = { title = 'Debugger Setup' }

  local ok, fidget = pcall(require, 'fidget')

  if ok and fidget.notify then
    fidget.notify(message, level, opts)
  else
    vim.notify(message, level, opts)
  end
end

-- Helper function to switch layouts
-- layout_nums can be a single number or a table of numbers
M.switch_layout = function(layout_nums)
  local dapui = require('dapui')

  -- Normalize to table
  if type(layout_nums) ~= 'table' then
    layout_nums = {layout_nums}
  end

  -- Close all currently open layouts
  for _, layout in ipairs(M.current_layouts) do
    dapui.close({ layout = layout })
  end

  -- Check if we're toggling off the same layout(s)
  local is_same = #M.current_layouts == #layout_nums
  if is_same then
    for i, layout in ipairs(layout_nums) do
      if M.current_layouts[i] ~= layout then
        is_same = false
        break
      end
    end
  end

  if is_same then
    -- Toggle off
    M.current_layouts = {}
  else
    -- Open new layout(s)
    for _, layout in ipairs(layout_nums) do
      dapui.open({ layout = layout })
    end
    M.current_layouts = layout_nums
  end
end

M.filetype_callbacks = {
  any = function()
    if M.loaded['nvim-dap'] then
      return
    end

    require('lz.n').trigger_load('nvim-dap')
    M.loaded['nvim-dap'] = true
  end,
  go = function()
    if M.loaded['nvim-dap-go'] then
      return
    end

    require('lz.n').trigger_load('nvim-dap-go')
    M.loaded['nvim-dap-go'] = true
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
  --[[ DEBUG KEYBINDINGS REFERENCE

  Execution Control:
    <leader>dc, <F5>     - Continue/Start debugging
    <leader>dC, <S-F5>   - Run Last
    <leader>dT, <C-F5>   - Terminate
    <leader>dR, <M-F5>   - Restart
    <leader>dt           - Run to Cursor
    <leader>dp           - Pause
    <leader>do, <F10>    - Step Over
    <leader>di, <F11>    - Step Into
    <leader>dO, <F12>    - Step Out

  Breakpoints:
    <leader>db, <F9>     - Toggle Breakpoint
    <leader>dB, <S-F9>   - Set Conditional Breakpoint
    <leader>dl, <C-F9>   - Set Log Point
    <leader>dX           - Clear All Breakpoints

  UI - Single Element Layouts (bottom, toggle):
    <leader>dus, <S-F8>  - Toggle Scopes
    <leader>duc, <C-F8>  - Toggle Console
    <leader>dur, <F8>    - Toggle REPL
    <leader>dub, <M-F8>  - Toggle Breakpoints
    <leader>duk, <C-S-F8>- Toggle Stacks
    <leader>duw, <M-C-F8>- Toggle Watches

  UI - Floating Windows (80% screen, centered):
    <leader>duS          - Float Scopes
    <leader>duC          - Float Console
    <leader>duR          - Float REPL
    <leader>duB          - Float Breakpoints
    <leader>duK          - Float Stacks
    <leader>duW          - Float Watches

  UI - Classic View:
    <leader>dui, <M-S-F8>- Toggle Classic UI (sidebar + bottom)

  Evaluation & Inspection:
    <leader>de           - Evaluate Expression (normal/visual mode)
    <leader>dk           - Stack Frame Up
    <leader>dj           - Stack Frame Down
  ]]--

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
    '<leader>dt',
    function()
      require('dap').run_to_cursor()
    end,
    'Run to Cursor'
  )

  map(
    '<leader>dp',
    function()
      require('dap').pause()
    end,
    'Pause'
  )

  map(
    '<leader>de',
    function()
      require('dapui').eval()
    end,
    'Evaluate Expression',
    {'n', 'v'}
  )

  map(
    '<leader>dk',
    function()
      require('dap').up()
    end,
    'Stack Frame Up'
  )

  map(
    '<leader>dj',
    function()
      require('dap').down()
    end,
    'Stack Frame Down'
  )

  map(
    {'<leader>dur', '<F8>'},
    function()
      M.switch_layout(3)
    end,
    'Toggle REPL'
  )

  map(
    {'<leader>dus', '<S-F8>'},
    function()
      M.switch_layout(1)
    end,
    'Toggle Scopes'
  )

  map(
    {'<leader>duc', '<C-F8>'},
    function()
      M.switch_layout(2)
    end,
    'Toggle Console'
  )

  map(
    {'<leader>dub', '<M-F8>'},
    function()
      M.switch_layout(4)
    end,
    'Toggle Breakpoints'
  )

  map(
    {'<leader>duk', '<C-S-F8>'},
    function()
      M.switch_layout(5)
    end,
    'Toggle Stacks'
  )

  map(
    {'<leader>duw', '<M-C-F8>'},
    function()
      M.switch_layout(6)
    end,
    'Toggle Watches'
  )

  map(
    {'<leader>dui', '<M-S-F8>'},
    function()
      M.switch_layout({7, 8})
    end,
    'Toggle Classic UI'
  )

  -- Floating window variants (80% of screen)
  local float_opts = {
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    enter = true,
    position = "center",
  }

  map(
    '<leader>duS',
    function()
      require('dapui').float_element('scopes', float_opts)
    end,
    'Float Scopes'
  )

  map(
    '<leader>duC',
    function()
      require('dapui').float_element('console', float_opts)
    end,
    'Float Console'
  )

  map(
    '<leader>duR',
    function()
      require('dapui').float_element('repl', float_opts)
    end,
    'Float REPL'
  )

  map(
    '<leader>duB',
    function()
      require('dapui').float_element('breakpoints', float_opts)
    end,
    'Float Breakpoints'
  )

  map(
    '<leader>duK',
    function()
      require('dapui').float_element('stacks', float_opts)
    end,
    'Float Stacks'
  )

  map(
    '<leader>duW',
    function()
      require('dapui').float_element('watches', float_opts)
    end,
    'Float Watches'
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
    '<leader>dX',
    function()
      require('dap').clear_breakpoints()
    end,
    'Clear All Breakpoints'
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

        -- Build ensure_installed list based on available language toolchains
        local debuggers = {}
        local missing_toolchains = {}

        -- Python debugger (requires python)
        if vim.fn.executable('python3') == 1 or vim.fn.executable('python') == 1 then
          table.insert(debuggers, 'debugpy')
        else
          table.insert(missing_toolchains, 'python/python3 (skipping: debugpy)')
        end

        -- Go debugger (requires go)
        if vim.fn.executable('go') == 1 then
          table.insert(debuggers, 'delve')
        else
          table.insert(missing_toolchains, 'go (skipping: delve)')
        end

        -- Notify about missing toolchains
        if #missing_toolchains > 0 then
          vim.defer_fn(function()
            M.notify(
              'Missing language toolchains:\n' .. table.concat(missing_toolchains, '\n'),
              vim.log.levels.WARN
            )
          end, 1000)
        end

        require('mason-nvim-dap').setup {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = false,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- Only install debuggers for languages that are available
          ensure_installed = debuggers,
        }

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup({
          expand_lines = true,
          controls = { enabled = true },
          floating = { border = 'rounded' },

          -- Set dapui window
          render = {
            max_type_length = 60,
            max_value_lines = 200,
          },

          layouts = {
            -- Layout 1: Scopes (default)
            {
              elements = {
                { id = 'scopes', size = 1.0 },
              },
              size = M.single_element_size,
              position = M.single_element_position,
            },
            -- Layout 2: Console
            {
              elements = {
                { id = 'console', size = 1.0 },
              },
              size = M.single_element_size,
              position = M.single_element_position,
            },
            -- Layout 3: REPL
            {
              elements = {
                { id = 'repl', size = 1.0 },
              },
              size = M.single_element_size,
              position = M.single_element_position,
            },
            -- Layout 4: Breakpoints
            {
              elements = {
                { id = 'breakpoints', size = 1.0 },
              },
              size = M.single_element_size,
              position = M.single_element_position,
            },
            -- Layout 5: Stacks
            {
              elements = {
                { id = 'stacks', size = 1.0 },
              },
              size = M.single_element_size,
              position = M.single_element_position,
            },
            -- Layout 6: Watches
            {
              elements = {
                { id = 'watches', size = 1.0 },
              },
              size = M.single_element_size,
              position = M.single_element_position,
            },
            -- Layout 7: Classic view - Left sidebar
            {
              elements = {
                { id = 'scopes', size = 0.25 },
                { id = 'breakpoints', size = 0.25 },
                { id = 'stacks', size = 0.25 },
                { id = 'watches', size = 0.25 },
              },
              size = 40,
              position = 'left',
            },
            -- Layout 8: Classic view - Bottom panel
            {
              elements = {
                { id = 'repl', size = 0.5 },
                { id = 'console', size = 0.5 },
              },
              size = 10,
              position = 'bottom',
            },
          },
        })

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

        -- Only open layout 1 (scopes) by default
        dap.listeners.after.event_initialized['dapui_config'] = function()
          M.switch_layout(1)
        end

        dap.listeners.before.event_terminated['dapui_config'] = function()
          dapui.close()
          M.current_layouts = {}
        end

        dap.listeners.before.event_exited['dapui_config'] = function()
          dapui.close()
          M.current_layouts = {}
        end
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
    {
      'nvim-dap-go',
      lazy = true,
      after = function()
        -- Install golang specific config
        require('dap-go').setup {
          delve = {
            -- On Windows delve must be run attached or it crashes.
            -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
            detached = vim.fn.has 'win32' == 0,
          },
        }
      end
    },
  })
end

return M
