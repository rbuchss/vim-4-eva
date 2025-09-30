local M = {
  packages = {
    available = {
      -- Add neovim specific plugins here from vim/pack/{label}/opt.
      -- This is necessary to avoid autolaoding these in standard vim.
      -- Which would happen in the vim/pack/{label}/start directory.
      'plenary.nvim',
      'telescope.nvim',
      'nvim-treesitter',
      'lazydev.nvim',
      'mason.nvim',
      'mason-lspconfig.nvim',
      'mason-tool-installer.nvim',
      'nvim-lspconfig',
      'fidget.nvim',
      'blink.cmp',
      'lush.nvim',
      'windsurf.nvim',
      'gitsigns.nvim',
      'statuscol.nvim',
      'which-key.nvim',
      'todo-comments.nvim',
    },
    enabled = {},
  },
}

function M.setup(config)
  local _config = config or {}
  local enabled = _config.packages or {}

  if type(enabled) == 'string' and enabled == 'all' then
    enabled = M.packages.available
  end

  M.add_packages(enabled)
end

function M.add_packages(packages)
  for _, package in ipairs(packages) do
    table.insert(M.packages.enabled, package)
    vim.cmd.packadd(package)
  end
end

return M
