local M = {}

function M.setup(config)
  require('vim_4_eva.before.plugin.node').setup(config)
  require('vim_4_eva.before.plugin.perl').setup(config)
  require('vim_4_eva.before.plugin.python').setup(config)
  require('vim_4_eva.before.plugin.ruby').setup(config)
end

return M
