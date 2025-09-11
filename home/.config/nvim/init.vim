set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Disables neovim python integration to speed up loading python files.
" Otherwise it takes forever to load these files.
"
" Alt option is to specify the python path. Eg:
"   let g:python3_host_prog = '/usr/bin/python3'
"
" Ref: https://neovim.io/doc/user/provider.html#g%3Apython3_host_prog
let g:loaded_python3_provider = 0

let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

source ~/.vimrc

" Add neovim specific plugins here from vim/pack/{label}/opt.
" This is necessary to avoid autolaoding these in standard vim.
" Which would happen in the vim/pack/{label}/start directory.
packadd plenary.nvim
packadd telescope.nvim
packadd nvim-treesitter
packadd blink.cmp
packadd lush.nvim
packadd windsurf.nvim

" make sure that all installed parsers are updated to the latest version via :TSUpdate
" TODO: make this not happen every load
TSUpdate

" required for lush colorschemes to work
set termguicolors

lua << EOF
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }

  -- Disable treesitter for help files since it cannot parse them correctly
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
      vim.treesitter.stop()
    end,
  })

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })

  local kind_icons = {
    -- LLM Provider icons
    claude = '󰋦',
    openai = '󱢆',
    codestral = '󱎥',
    gemini = '',
    Groq = '',
    Openrouter = '󱂇',
    Ollama = '󰳆',
    ['Llama.cpp'] = '󰳆',
    Deepseek = ''
  }

  local source_icons = {
    minuet = '󱗻',
    orgmode = '',
    otter = '󰼁',
    nvim_lsp = '',
    lsp = '',
    buffer = '',
    luasnip = '',
    snippets = '',
    path = '',
    git = '',
    tags = '',
    cmdline = '󰘳',
    latex_symbols = '',
    cmp_nvim_r = '󰟔',
    codeium = '󰩂',
    -- FALLBACK
    fallback = '󰜚',
  }

  local blink_cmp = {
    _sources = { 'lsp', 'path', 'snippets', 'buffer' },
    _providers = {
      codeium = {
        name = 'Codeium',
        module = 'codeium.blink',
        async = true,
        _enabled = false,
      },
    },
  }

  function blink_cmp.sources()
    return blink_cmp._sources
  end

  function blink_cmp:add_source(source)
    table.insert(self._sources, source)
  end

  function blink_cmp:remove_source(source)
    self._sources = vim.tbl_filter(
      function(s) return s ~= source end,
      self._sources
    )
  end

  function blink_cmp:enable_provider(provider)
    self._providers[provider]._enabled = true
    self:add_source(provider)
  end

  function blink_cmp:disable_provider(provider)
    self._providers[provider]._enabled = false
    self:remove_source(provider)
  end

  function blink_cmp:provider_enabled_fn(provider)
    return function()
      return self._providers[provider]._enabled
    end
  end

  function blink_cmp:provider(provider)
    local public_config = {}
    local source = self._providers[provider]

    for key, value in pairs(source) do
      if not key:match('^_') then
        public_config[key] = value
      end
    end

    public_config.enabled = self:provider_enabled_fn(provider)

    return public_config
  end

  function blink_cmp:providers()
    local providers = {}

    for key, value in pairs(self._providers) do
      providers[key] = self:provider(key)
    end

    return providers
  end

  blink_cmp.config = {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      preset = 'super-tab',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      kind_icons = kind_icons,
    },

    completion = {
      -- only show menu on manual <C-space>
      menu = {
        auto_show = false,
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind' },
            { 'source_icon' },
          },
          components = {
            source_icon = {
              -- don't truncate source_icon
              ellipsis = false,
              text = function(ctx)
                return source_icons[ctx.source_name:lower()] or source_icons.fallback
              end,
              highlight = 'BlinkCmpSource',
            },
          },
        },
      },

      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = true, auto_show_delay_ms = 500 },

      ghost_text = {
        enabled = true,
        show_with_menu = false, -- only show when menu is closed
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = blink_cmp.sources,
      providers = blink_cmp:providers(),
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }

  require('blink.cmp').setup(blink_cmp.config)

  AI = {
    providers = {},
  }

  function AI.set_provider(provider)
    if not AI.providers[provider] and provider ~= 'disabled' then
      print(string.format('Unsupported provider: %s', provider))
      return
    end

    local current_provider = vim.g.ai_provider or 'disabled'

    if current_provider == 'disabled' and provider == 'disabled' then
      print('Already disabled')
      return
    end

    if current_provider == provider then
      print(string.format('Already using provider: %s', provider))
      return
    end

    if current_provider and AI.providers[current_provider] then
      AI.providers[current_provider]:teardown()
    end

    if provider == 'disabled' then
      vim.g.ai_provider = nil
    elseif AI.providers[provider] then
      vim.g.ai_provider = provider
      AI.providers[provider]:setup()
    end
  end

  function AI.register_provider(provider)
    AI.providers[provider.name] = provider
  end

  local codeium_provider = {
    name = 'codeium',
    configured = false,
  }

  function codeium_provider:setup()
    if not self.configured then
      require('codeium').setup({
         -- We disable auto registering the cmp source since we are using blink.cmp.
         enable_cmp_source = false,
         virtual_text = {
           -- We use blink.cmp to show virtual text so we disable it here.
           -- Disabling this means that we also get less info with the statusline.
           -- Such as the number of completions available, waiting for the api response, etc.
           -- However, basic server status such as auth are still shown in the statusline.
           -- This also means that the keybindings for accepting completions
           -- is handled by blink.cmp.
           --
           enabled = false,
         }
      })

      -- For the custom status line to work we need to set using_status_line = true
      -- and set the callback for redrawstatus
      -- See: https://github.com/Exafunction/windsurf.nvim/blob/821b570b526dbb05b57aa4ded578b709a704a38a/lua/codeium/virtual_text.lua#L543-L552
      --
      require('codeium.virtual_text').set_statusbar_refresh(function()
        vim.cmd("redrawstatus")
      end)

      self.configured = true
    end

    require('codeium').enable()

    blink_cmp:enable_provider('codeium')

    vim.keymap.set('n', '<leader>aa', function() vim.cmd('Codeium Chat') end)
  end

  function codeium_provider:teardown()
    vim.keymap.del('n', '<leader>aa')

    blink_cmp:disable_provider('codeium')

    require('codeium').disable()
  end

  function codeium_provider:status()
    local server = require('codeium').s
    local server_status = server.check_status()

    if not server.enabled then
      return {
        state = 'disabled',
        text = '',
      }
    end

    if server_status.api_key_error ~= nil then
      return {
        state = 'logged_out',
        text = server_status.api_key_error,
      }
    end

    -- NOTE: that this will always be idle if the server is enabled and authenticated, but virtual text is disabled.
    --
    -- This is a custom version of the status line based on:
    -- https://github.com/Exafunction/windsurf.nvim/blob/821b570b526dbb05b57aa4ded578b709a704a38a/lua/codeium/virtual_text.lua#L520-L537
    --
    local status = require('codeium.virtual_text').status()

    if status.state == 'completions' then
      if status.total > 0 then
        return {
          state = 'enabled',
          text = string.format('%d/%d', status.current, status.total),
        }
      end

      return {
        state = 'enabled',
        text = '0',
      }
    elseif status.state == 'waiting' then
      return {
        state = 'enabled',
        text = '*',
      }
    elseif status.state == 'idle' then
      return {
        state = 'enabled',
        text = '',
      }
    else
      return {
        state = 'enabled',
        text = '?',
      }
    end
  end

  AI.register_provider(codeium_provider)

  vim.api.nvim_create_user_command('AI', function(opts)
    local args = opts.fargs
    AI.set_provider(args[1])
  end, {
    nargs = 1,
    complete = function()
      local providers = { 'disabled' }

      for provider, _ in pairs(AI.providers) do
        table.insert(providers, provider)
      end

      return providers
    end,
  })

  CustomStatus = {}

  function CustomStatus.ai_status()
    local status_symbols = {
      error = '❌',
      disabled = '🙈',
      logged_out = '🚫',
      enabled = '🤖',
    }

    local provider = vim.g.ai_provider

    if not provider then
      return string.format(
        '[%s]',
        status_symbols.disabled
      )
    end

    if not AI.providers[provider] then
      return string.format(
        '[%s%s]',
        status_symbols.error,
        string.format('Unsupported provider: %s', provider)
      )
    end

    local status = AI.providers[provider]:status()

    return string.format(
      '[%s%s]',
      status_symbols[status.state],
      status.text
    )
  end
EOF
