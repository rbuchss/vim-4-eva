local M = {
  codeium_provider = {
    name = 'codeium',
    configured = false,
  },
}

function M.setup(_)
  require('vim_4_eva.plugin.settings.ai').register_provider(M.codeium_provider)
end

function M.codeium_provider:setup()
  if not self.configured then
    vim.cmd.packadd('windsurf.nvim')

    require('codeium').setup({
       -- We disable auto registering the cmp source since we are using blink.cmp.
       enable_cmp_source = false,
       virtual_text = {
         -- We use blink.cmp to show virtual text so we disable it here.
         -- Disabling this means that we also get less info with the statusline.
         -- Such as the number of completions available, waiting for the api response, etc.
         -- However, basic server status such as auth are still shown in the statusline.
         -- This also means that the keybindings for accepting completions
         -- is handled by blink.cmp.
         --
         enabled = false,
       }
    })

    -- For the custom status line to work we need to set using_status_line = true
    -- and set the callback for redrawstatus
    -- See: https://github.com/Exafunction/windsurf.nvim/blob/821b570b526dbb05b57aa4ded578b709a704a38a/lua/codeium/virtual_text.lua#L543-L552
    --
    require('codeium.virtual_text').set_statusbar_refresh(function()
      vim.cmd('redrawstatus')
    end)

    self.configured = true
  end

  require('codeium').enable()

  require('vim_4_eva.plugin.settings.blink'):enable_provider('codeium')

  vim.keymap.set('n', '<leader>aa', function() vim.cmd('Codeium Chat') end)
end

function M.codeium_provider:teardown()
  vim.keymap.del('n', '<leader>aa')

  require('vim_4_eva.plugin.settings.blink'):disable_provider('codeium')

  require('codeium').disable()
end

function M.codeium_provider:status()
  local server = require('codeium').s
  local server_status = server.check_status()

  if not server.enabled then
    return {
      state = 'disabled',
      text = '',
    }
  end

  if server_status.api_key_error ~= nil then
    return {
      state = 'logged_out',
      text = server_status.api_key_error,
    }
  end

  -- NOTE: that this will always be idle if the server is enabled and authenticated, but virtual text is disabled.
  --
  -- This is a custom version of the status line based on:
  -- https://github.com/Exafunction/windsurf.nvim/blob/821b570b526dbb05b57aa4ded578b709a704a38a/lua/codeium/virtual_text.lua#L520-L537
  --
  local status = require('codeium.virtual_text').status()

  if status.state == 'completions' then
    if status.total > 0 then
      return {
        state = 'enabled',
        text = string.format('%d/%d', status.current, status.total),
      }
    end

    return {
      state = 'enabled',
      text = '0',
    }
  elseif status.state == 'waiting' then
    return {
      state = 'enabled',
      text = '*',
    }
  elseif status.state == 'idle' then
    return {
      state = 'enabled',
      text = '',
    }
  else
    return {
      state = 'enabled',
      text = '?',
    }
  end
end

return M
