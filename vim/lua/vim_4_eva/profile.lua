local M = {
  before = {},
  after = {},
}

function M.setup(callback)
  M.before.setup()

  if callback ~= nil and type(callback) ~= 'function' then
    error('callback must be a function, got ' .. type(callback))
  end

  local _callback = callback or function() end
  _callback()

  M.after.setup()
end

function M.before.setup()
  require('vim_4_eva.before.plugin').setup({})
end

function M.after.setup()
  require('vim_4_eva.pack').eager.load()
  require('vim_4_eva.plugin').setup({})
  require('vim_4_eva.ftplugin').setup({})
  require('vim_4_eva.pack').lazy.load()

  vim.cmd.colorscheme(
    require('vim_4_eva.plugin.settings.colors').random_color({
      colors = {
        'catppuccin',
        'catppuccin-frappe',
        'catppuccin-macchiato',
        'catppuccin-mocha',
        'kanagawa',
        'kanagawa-dragon',
        'kanagawa-wave',
        'tokyonight',
        'tokyonight-moon',
        'tokyonight-night',
        'tokyonight-storm',
      },
    })
  )
end

return M
