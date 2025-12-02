local M = {}

function M.setup(config)
  require('vim_4_eva.plugin.settings.ai').setup(config)
  require('vim_4_eva.plugin.settings.blink').setup(config)
  require('vim_4_eva.plugin.settings.claude').setup(config)
  require('vim_4_eva.plugin.settings.codeium').setup(config)
  require('vim_4_eva.plugin.settings.colors').setup(config)
  require('vim_4_eva.plugin.settings.debugger').setup(config)
  require('vim_4_eva.plugin.settings.diagnostic').setup(config)
  require('vim_4_eva.plugin.settings.fidget').setup(config)
  require('vim_4_eva.plugin.settings.gitsigns').setup(config)
  require('vim_4_eva.plugin.settings.lazydev').setup(config)
  require('vim_4_eva.plugin.settings.lsp').setup(config)
  require('vim_4_eva.plugin.settings.statuscol').setup(config)
  require('vim_4_eva.plugin.settings.statusline').setup(config)
  require('vim_4_eva.plugin.settings.telescope').setup(config)
  require('vim_4_eva.plugin.settings.todo-comments').setup(config)
  require('vim_4_eva.plugin.settings.treesitter').setup(config)
  require('vim_4_eva.plugin.settings.trouble').setup(config)
  require('vim_4_eva.plugin.settings.which-key').setup(config)
end

return M
