local M = {}

function M.setup(_)
  -- Set conceallevel to 2 for Obsidian.nvim UI features
  -- (concealing markdown syntax for better readability)
  vim.opt_local.conceallevel = 2
end

return M
