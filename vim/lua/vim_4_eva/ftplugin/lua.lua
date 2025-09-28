local M = {}

function M.setup(_)
  require('lazydev').setup({
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  })
end

return M
