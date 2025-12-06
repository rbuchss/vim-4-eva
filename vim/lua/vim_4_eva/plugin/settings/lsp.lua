local M = {}

function M.notify(message, level)
  level = level or vim.log.levels.WARN
  local opts = { title = 'LSP Setup' }

  local ok, fidget = pcall(require, 'fidget')

  if ok and fidget.notify then
    fidget.notify(message, level, opts)
  else
    vim.notify(message, level, opts)
  end
end

function M.setup(_)
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. Available keys are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --  - settings (table): Override the default settings passed when initializing the server.
  --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- But for many setups, the LSP (`ts_ls`) will work just fine
    -- ts_ls = {},

    bashls = {},

    lua_ls = {
      -- cmd = { ... },
      -- filetypes = { ... },
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },
      on_init = function(client)
        local join = vim.fs.joinpath
        local path = client.workspace_folders[1].name

        -- Don't do anything if there is project local config
        if vim.uv.fs_stat(join(path, '.luarc.json'))
          or vim.uv.fs_stat(join(path, '.luarc.jsonc'))
        then
          return
        end

        local nvim_settings = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'}
          },
          workspace = {
            checkThirdParty = false,
            library = {
              -- Make the server aware of Neovim runtime files
              vim.env.VIMRUNTIME,
              vim.fn.stdpath('config'),
            },
          },
        }

        client.config.settings.Lua = vim.tbl_deep_extend(
          'force',
          client.config.settings.Lua,
          nvim_settings
        )
      end,
    },

    vimls = {},
  }

  -- Formatters to install via Mason
  local formatters = {}

  -- Linters to install via Mason
  local linters = {}

  -- Track missing toolchains for notification
  local missing_toolchains = {}

  -- Python tooling
  if vim.fn.executable('python3') == 1 or vim.fn.executable('python') == 1 then
    servers.basedpyright = {}
    table.insert(linters, 'ruff')
  else
    table.insert(missing_toolchains, 'python/python3 (skipping: basedpyright, ruff)')
  end

  -- Go tooling
  if vim.fn.executable('go') == 1 then
    servers.gopls = {}
    table.insert(formatters, 'gofumpt')
    table.insert(linters, 'golangci-lint')
  else
    table.insert(missing_toolchains, 'go (skipping: gopls, gofumpt, golangci-lint)')
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

  require('vim_4_eva.pack').lazy.register({
    {
      'nvim-lspconfig',
      event = 'DeferredUIEnter',
      after = function()
        require('lz.n').trigger_load({
          'mason-lspconfig.nvim',
          'mason-tool-installer.nvim',
          'fidget.nvim',
        })
      end,
    },
    {
      'mason.nvim',
      lazy = true,
      after = function()
        require('mason').setup({})
      end,
    },
    {
      'mason-tool-installer.nvim',
      lazy = true,
      before = function()
        require('lz.n').trigger_load('mason.nvim')
      end,
      after = function()
        -- Ensure the servers and tools above are installed
        --
        -- To check the current status of installed tools and/or manually install
        -- other tools, you can run
        --    :Mason
        --
        -- You can press `g?` for help in this menu.
        --
        -- `mason` had to be setup earlier: to configure its options see the
        -- `dependencies` table for `nvim-lspconfig` above.
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})

        -- Add formatters and linters to the ensure_installed list
        vim.list_extend(ensure_installed, formatters)
        vim.list_extend(ensure_installed, linters)

        require('mason-tool-installer').setup({
          ensure_installed = ensure_installed,
        })

        -- Manually trigger installation since we load after VimEnter
        -- This compensates for missing the VimEnter autocmd that mason-tool-installer sets up
        vim.defer_fn(function()
          require('mason-tool-installer').check_install()
        end, 100)
      end,
    },
    {
      'mason-lspconfig.nvim',
      lazy = true,
      before = function()
        require('lz.n').trigger_load({
          'mason.nvim',
          'blink.cmp',
        })
      end,
      after = function()
        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- Initialize mason-lspconfig, specifying servers to auto-install
        require('mason-lspconfig').setup({
          ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
          automatic_installation = false,
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              -- This handles overriding only values explicitly passed
              -- by the server configuration above. Useful when disabling
              -- certain features of an LSP (for example, turning off formatting for ts_ls)
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

              -- TODO: consider migrating this to this new method:
              --
              --    vim.lsp.config(server_name, server)
              --
              require('lspconfig')[server_name].setup(server)
            end,
          },
        })
      end,
    },
  })
end

return M
