local M = {
  _sources = { 'lsp', 'path', 'snippets', 'buffer' }, -- lazydev will be added when it loads
  -- TODO: allow providers to add be added out of this module to decouple this.
  _providers = {
    lazydev = {
      module = 'lazydev.integrations.blink',
      score_offset = 100,
      _enabled = false, -- Disabled by default, will be enabled when lazydev loads
    },
    codeium = {
      name = 'Codeium',
      module = 'codeium.blink',
      async = true,
      _enabled = false,
    },
  },
}

-- TODO: allow these to be changed via g vars or the setup function.
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

-- TODO: allow these to be changed via g vars or the setup function.
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

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    {
      'blink.cmp',
      event = 'DeferredUIEnter',
      after = function()
        require('blink.cmp').setup(M.config)
      end,
    },
  })
end

function M.sources()
  return M._sources
end

function M:add_source(source)
  table.insert(self._sources, source)
end

function M:remove_source(source)
  self._sources = vim.tbl_filter(
    function(s) return s ~= source end,
    self._sources
  )
end

function M:enable_provider(provider)
  self._providers[provider]._enabled = true
  self:add_source(provider)
end

function M:disable_provider(provider)
  self._providers[provider]._enabled = false
  self:remove_source(provider)
end

function M:provider_enabled_fn(provider)
  return function()
    return self._providers[provider]._enabled
  end
end

function M:provider(provider)
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

function M:providers()
  local providers = {}

  for key, value in pairs(self._providers) do
    providers[key] = self:provider(key)
  end

  return providers
end

M.config = {
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
    default = M.sources,
    providers = M:providers(),
  },

  -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
  -- You may use a lua implementation instead by using `implementation = 'lua'` or fallback to the lua implementation,
  -- when the Rust fuzzy matcher is not available, by using `implementation = 'prefer_rust'`
  --
  -- See the fuzzy documentation for more information
  fuzzy = { implementation = 'prefer_rust_with_warning' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}

return M
