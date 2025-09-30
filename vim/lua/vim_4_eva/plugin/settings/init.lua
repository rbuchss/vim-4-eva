local M = {}

function M.setup(config)
  require('vim_4_eva.plugin.settings.ai').setup(config)
  require('vim_4_eva.plugin.settings.blink').setup(config)
  require('vim_4_eva.plugin.settings.codeium').setup(config)
  require('vim_4_eva.plugin.settings.colors').setup(config)
  require('vim_4_eva.plugin.settings.diagnostic').setup(config)
  require('vim_4_eva.plugin.settings.gitsigns').setup(config)
  require('vim_4_eva.plugin.settings.lsp').setup(config)
  require('vim_4_eva.plugin.settings.node').setup(config)
  require('vim_4_eva.plugin.settings.perl').setup(config)
  require('vim_4_eva.plugin.settings.python').setup(config)
  require('vim_4_eva.plugin.settings.ruby').setup(config)
  require('vim_4_eva.plugin.settings.statuscol').setup(config)
  require('vim_4_eva.plugin.settings.statusline').setup(config)
  require('vim_4_eva.plugin.settings.treesitter').setup(config)
  require('vim_4_eva.plugin.settings.which-key').setup(config)
end

return M
