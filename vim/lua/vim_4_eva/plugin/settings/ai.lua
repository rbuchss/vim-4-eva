local M = {
  providers = {},
}

-- TODO: allow this to configure/register providers
function M.setup(config)
end

function M.set_provider(provider)
  if not M.providers[provider] and provider ~= 'disabled' then
    print(string.format('Unsupported provider: %s', provider))
    return
  end

  local current_provider = vim.g.ai_provider or 'disabled'

  if current_provider == 'disabled' and provider == 'disabled' then
    print('Already disabled')
    return
  end

  if current_provider == provider then
    print(string.format('Already using provider: %s', provider))
    return
  end

  if current_provider and M.providers[current_provider] then
    M.providers[current_provider]:teardown()
  end

  if provider == 'disabled' then
    vim.g.ai_provider = nil
  elseif M.providers[provider] then
    vim.g.ai_provider = provider
    M.providers[provider]:setup()
  end
end

function M.register_provider(provider)
  M.providers[provider.name] = provider
end

return M
