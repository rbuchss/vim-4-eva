local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'markdown-preview.nvim',
    cmd = {
      'MarkdownPreviewToggle',
      'MarkdownPreview',
      'MarkdownPreviewStop',
    },
    after = function()
      -- Install/update if needed (function is idempotent)
      vim.fn['mkdp#util#install']()

      -- Manually create commands that call the VimL autoload functions
      vim.api.nvim_create_user_command('MarkdownPreview', function()
        vim.fn['mkdp#util#open_preview_page']()
      end, {})

      vim.api.nvim_create_user_command('MarkdownPreviewStop', function()
        vim.fn['mkdp#util#stop_preview']()
      end, {})

      vim.api.nvim_create_user_command('MarkdownPreviewToggle', function()
        vim.fn['mkdp#util#toggle_preview']()
      end, {})
    end,
  })
end

return M
