local M = {}

function M.setup(packages)
  for _, package in ipairs(packages) do
    vim.cmd.packadd(package)
  end
end

return M
