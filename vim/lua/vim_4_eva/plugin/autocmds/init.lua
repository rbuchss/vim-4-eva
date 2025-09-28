local M = {}

function M.setup(config)
  require('vim_4_eva.plugin.autocmds.lsp').setup(config)
  require('vim_4_eva.plugin.autocmds.treesitter').setup(config)
  require('vim_4_eva.plugin.autocmds.yank').setup(config)
end

return M
