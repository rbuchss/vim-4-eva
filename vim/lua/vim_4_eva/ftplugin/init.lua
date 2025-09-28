local M = {
  module_cache = {},
  verbose = false,
}

function M.setup(config)
  if config.verbose then
    M.verbose = true
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

  M.notify('Cache-miss - Try load ftplugin for ' .. filetype .. ': ' .. module_name, vim.log.levels.TRACE)

  -- TODO: consider registering available modules to speed this up?
  --
  -- For example this now tries to require all any filetype as a module - E.g:
  --
  --   Try ftplugin for lua: vim_4_eva.ftplugin.lua
  --   Found ftplugin for lua: vim_4_eva.ftplugin.lua
  --   Found in cache - Skip ftplugin for lua: vim_4_eva.ftplugin.lua
  --   Found in cache - Skip ftplugin for lua: vim_4_eva.ftplugin.lua
  --   Try ftplugin for fidget: vim_4_eva.ftplugin.fidget
  --   No ftplugin found for fidget: vim_4_eva.ftplugin.fidget
  --   Try ftplugin for blink-cmp-menu: vim_4_eva.ftplugin.blink-cmp-menu
  --   No ftplugin found for blink-cmp-menu: vim_4_eva.ftplugin.blink-cmp-menu
  --   Try ftplugin for vim: vim_4_eva.ftplugin.vim
  --   No ftplugin found for vim: vim_4_eva.ftplugin.vim
  --
  local ok, module = pcall(require, module_name)

  if not ok then
    M.notify('No ftplugin found for ' .. filetype .. ': ' .. module_name, vim.log.levels.TRACE)
    return -- Module doesn't exist, skip silently
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
  -- TODO: allow any levels above ERROR or some config?
  if M.verbose or level == vim.log.levels.ERROR then
    vim.notify(message, level, opts)
  end
end

return M
