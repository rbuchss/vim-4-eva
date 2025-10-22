local M = {
  packages = {
    available = {
      -- Add neovim specific plugins here from vim/pack/{label}/opt.
      -- This is necessary to avoid autolaoding these in standard vim.
      -- Which would happen in the vim/pack/{label}/start directory.
      'lz.n',

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
      'zombat.nvim',
      'windsurf.nvim',
      'gitsigns.nvim',
      'statuscol.nvim',
      'which-key.nvim',
      'todo-comments.nvim',
      'nvim-dap',
      'nvim-nio',
      'nvim-dap-ui',
      'mason-nvim-dap.nvim',
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

---Normalize plugin specs to a consistent key-value table structure
---Handles: strings, tables, and module names (strings that refer to Lua modules)
---@param items table|string A list of plugin specs, or a string module name
---@return table<string, any> normalized Map of plugin names to their specs
function M.normalize_plugin_specs(items)
  -- Handle string input (module name)
  if type(items) == "string" then
    local ok, module = pcall(require, items)
    if not ok then
      vim.notify(
        string.format("Failed to load plugin module '%s': %s", items, module),
        vim.log.levels.ERROR
      )
      return {}
    end

    -- Module should return a table
    if type(module) ~= "table" then
      vim.notify(
        string.format("Plugin module '%s' must return a table, got %s", items, type(module)),
        vim.log.levels.ERROR
      )
      return {}
    end

    items = module
  end

  -- Ensure we have a table at this point
  if type(items) ~= "table" then
    vim.notify(
      string.format("normalize_plugin_specs expects a table or string, got %s", type(items)),
      vim.log.levels.ERROR
    )
    return {}
  end

  local normalized = {}

  -- Check if items is a single plugin spec (has [1] field with string)
  -- vs a list of specs
  if type(items[1]) == "string" and not vim.islist(items[1]) then
    -- This might be a single plugin spec table
    -- e.g., { "plugin.nvim", event = "BufRead" }
    -- Check if there are non-numeric keys (indicating config fields)
    local has_config_keys = false
    for k, _ in pairs(items) do
      if type(k) ~= "number" then
        has_config_keys = true
        break
      end
    end

    if has_config_keys then
      -- Single plugin spec
      local key = items[1]
      normalized[key] = items
      return normalized
    end
  end

  -- Process as list of specs
  for i, item in ipairs(items) do
    local item_type = type(item)

    if item_type == "string" then
      -- String spec: just the plugin name
      normalized[item] = item

    elseif item_type == "table" then
      local key = item[1]

      -- Validate the plugin name
      if not key then
        vim.notify(
          string.format("Plugin spec at index %d is missing a name (no [1] element)", i),
          vim.log.levels.WARN
        )
      elseif type(key) ~= "string" then
        vim.notify(
          string.format(
            "Plugin spec at index %d has invalid name type (expected string, got %s): %s",
            i,
            type(key),
            vim.inspect(key)
          ),
          vim.log.levels.WARN
        )
      else
        -- Valid plugin spec
        if normalized[key] then
          vim.notify(
            string.format(
              "Duplicate plugin name '%s' at index %d (already defined). Using last definition.",
              key,
              i
            ),
            vim.log.levels.WARN
          )
        end
        normalized[key] = item
      end

    else
      -- Invalid type
      vim.notify(
        string.format(
          "Plugin spec at index %d has invalid type (expected string or table, got %s)",
          i,
          item_type
        ),
        vim.log.levels.WARN
      )
    end
  end

  return normalized
end

return M
