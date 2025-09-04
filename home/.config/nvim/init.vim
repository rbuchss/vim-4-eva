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

  require('blink.cmp').setup({
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
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- only show menu on manual <C-space>
      menu = { auto_show = false },

      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = true, auto_show_delay_ms = 500 },

      ghost_text = {
        enabled = true,
        -- you may want to set the following options
        show_with_menu = false, -- only show when menu is closed
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  })
EOF
