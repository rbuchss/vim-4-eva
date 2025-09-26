local M = {}

function M.setup(config)
  require('vim_4_eva.plugin.autocmds').setup(config)
  require('vim_4_eva.plugin.commands').setup(config)
  require('vim_4_eva.plugin.mappings').setup(config)
  require('vim_4_eva.plugin.settings').setup(config)
end

return M
