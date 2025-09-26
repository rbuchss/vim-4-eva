local M = {}

-- TODO: allow this to configure/register providers
function M.setup(config)
  local ai = require('vim_4_eva.plugin.settings.ai')

  -- TODO: move this to autocmds or commands?
  vim.api.nvim_create_user_command('AI', function(opts)
    local args = opts.fargs
    ai.set_provider(args[1])
  end, {
    nargs = 1,
    complete = function()
      local providers = { 'disabled' }

      for provider, _ in pairs(ai.providers) do
        table.insert(providers, provider)
      end

      return providers
    end,
  })
end

return M
