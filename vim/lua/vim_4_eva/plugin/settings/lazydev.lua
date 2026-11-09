local M = {}

function M.setup(_)
  -- Register the blink.cmp source here so it is available when blink.cmp
  -- loads; it stays disabled until lazydev itself loads below
  require('vim_4_eva.plugin.settings.blink'):register_provider('lazydev', {
    module = 'lazydev.integrations.blink',
    score_offset = 100,
  })

  require('vim_4_eva.pack').lazy.register({
    'lazydev.nvim',
    ft = 'lua',
    after = function()
      require('lazydev').setup({
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      })

      -- Now enable the lazydev provider in blink.cmp
      local blink_settings = require('vim_4_eva.plugin.settings.blink')
      blink_settings:enable_provider('lazydev')
    end,
  })
end

return M
