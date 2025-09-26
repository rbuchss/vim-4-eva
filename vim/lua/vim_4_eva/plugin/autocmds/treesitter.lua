local M = {}

function M.setup(config)
  -- Disable treesitter for help files since it cannot parse them correctly
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
      vim.treesitter.stop()
    end,
  })
end

return M
