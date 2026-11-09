local M = {
  available = {},
  module_cache = {},
  -- Minimum message level that surfaces without verbose mode; messages below
  -- it are only shown when verbose is set
  notify_level = vim.log.levels.ERROR,
  verbose = false,
}

function M.setup(config)
  if config.verbose then
    M.verbose = true
  end

  if config.notify_level then
    M.notify_level = config.notify_level
  end

  -- Register the available ftplugin modules up front, so FileType events for
  -- filetypes without a module resolve with a table lookup instead of a
  -- require that walks package.path on every event. init.lua is the loader
  -- itself, not a per-filetype module.
  for _, file in ipairs(vim.api.nvim_get_runtime_file('lua/vim_4_eva/ftplugin/*.lua', true)) do
    local name = file:match('([^/]+)%.lua$')

    if name ~= 'init' then
      M.available[name] = true
    end
  end

  local ftplugin_group = vim.api.nvim_create_augroup(
    'vim_4_eva#lua#ftplugin_loader',
    { clear = true }
  )

  vim.api.nvim_create_autocmd('FileType', {
    group = ftplugin_group,
    pattern = '*',
    callback = function(args)
      M.load_ftplugin(args.match, config)
    end,
  })
end

function M.load_ftplugin(filetype, config)
  local module_name = 'vim_4_eva.ftplugin.' .. filetype

  -- Skip if the module is already loaded.
  if M.module_cache[module_name] then
    M.notify('Cache-hit - Skip ftplugin for ' .. filetype .. ': ' .. module_name, vim.log.levels.TRACE)
    return
  end

  if not M.available[filetype] then
    M.notify('No ftplugin found for ' .. filetype .. ': ' .. module_name, vim.log.levels.TRACE)
    return
  end

  M.notify('Cache-miss - Try load ftplugin for ' .. filetype .. ': ' .. module_name, vim.log.levels.TRACE)

  local ok, module = pcall(require, module_name)

  if not ok then
    M.notify('Error loading ftplugin for ' .. filetype .. ': ' .. module, vim.log.levels.ERROR)
    return
  end

  M.notify('Found ftplugin for ' .. filetype .. ': ' .. module_name, vim.log.levels.TRACE)

  if type(module.setup) == 'function' then
    local setup_ok, err = pcall(module.setup, config)

    if not setup_ok or err then
      M.notify('Error in ftplugin setup for ' .. filetype .. ': ' .. err, vim.log.levels.ERROR)
    else
      M.notify('Success in ftplugin setup for ' .. filetype .. ': ' .. module_name, vim.log.levels.TRACE)
      -- Add module to the cache to skip load for the same filetype.
      M.module_cache[module_name] = true
    end
  end
end

function M.notify(message, level, opts)
  if M.verbose or (level or vim.log.levels.INFO) >= M.notify_level then
    vim.notify(message, level, opts)
  end
end

return M
