local M = {}

-- TODO: allow configs to be used here.
-- For example status_symbols, etc.
--
function M.setup(config)
end

function M.ai_status()
  local status_symbols = {
    error = '❌',
    disabled = '🙈',
    logged_out = '🚫',
    enabled = '🤖',
  }

  local ai = require('vim_4_eva.plugin.settings.ai')
  local provider = vim.g.ai_provider

  if not provider then
    return string.format(
      '%s',
      status_symbols.disabled
    )
  end

  if not ai.providers[provider] then
    return string.format(
      '%s%s',
      status_symbols.error,
      string.format('Unsupported provider: %s', provider)
    )
  end

  local status = ai.providers[provider]:status()

  return string.format(
    '%s%s',
    status_symbols[status.state],
    status.text
  )
end

return M
