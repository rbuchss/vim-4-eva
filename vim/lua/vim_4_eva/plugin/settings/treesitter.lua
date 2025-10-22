local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'nvim-treesitter',
    event = 'DeferredUIEnter',
    after = function()
      -- Make sure that all installed parsers are updated to the latest version via :TSUpdate
      -- TODO: make this not happen every load possibly with some debouncing.
      --
      -- For now , just disabling and relying on manually running this.
      --
      -- Note that if enabled with auto_install=true this errors with using the same tmp dirs.
      --
      -- vim.cmd.TSUpdate()

      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or 'all' (the listed parsers MUST always be installed)
        ensure_installed = {
          'bash',
          -- 'c',
          'diff',
          'lua',
          'vim',
          'vimdoc',
          -- 'query',
          'markdown',
          'markdown_inline',
        },

        -- Install parsers asynchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = false,

        -- List of parsers to ignore installing (or 'all')
        ignore_install = {},

        highlight = {
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  })
end

return M
