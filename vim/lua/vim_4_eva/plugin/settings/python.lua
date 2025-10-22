local M = {}

function M.setup(_)
  -- Disables neovim python integration to speed up loading python files.
  -- Otherwise it takes forever to load these files.
  --
  -- Alt option is to specify the python path. Eg:
  --   vim.g.python3_host_prog = '/usr/bin/python3'
  --
  -- Ref: https://neovim.io/doc/user/provider.html#g%3Apython3_host_prog
  vim.g.loaded_python3_provider = 0
end

return M
