local M = {}

function M.setup(_)
  require('vim_4_eva.pack').eager.load()
  require('vim_4_eva.plugin').setup({})
  require('vim_4_eva.ftplugin').setup({})
  require('vim_4_eva.pack').lazy.load()

  vim.cmd.colorscheme 'zombat'
end

return M
