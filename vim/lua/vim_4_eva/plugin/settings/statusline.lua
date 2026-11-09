local M = {}

-- Statusline config, provided via setup(). The statusline section can
-- override the default symbols below, e.g.
--   { statusline = { status_symbols = { enabled = '*' } } }
local config = {}

-- Default symbols for each provider state in the ai_status component
local default_status_symbols = {
  error = '❌',
  disabled = '🙈',
  logged_out = '🚫',
  enabled = '🤖',
}

function M.setup(user_config)
  config = user_config or {}
end

function M.ai_status()
  local status_symbols = vim.tbl_deep_extend(
    'force',
    default_status_symbols,
    (config.statusline or {}).status_symbols or {}
  )

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
