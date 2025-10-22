local normalize = require('vim_4_eva.pack').normalize_plugin_specs

describe("normalize_plugin_specs", function()
  describe("string inputs", function()
    it("should handle a list of plugin name strings", function()
      local input = {
        "telescope.nvim",
        "plenary.nvim",
      }

      local result = normalize(input)

      assert.equals("telescope.nvim", result["telescope.nvim"])
      assert.equals("plenary.nvim", result["plenary.nvim"])
      assert.equals(2, vim.tbl_count(result))
    end)

    it("should handle empty string list", function()
      local result = normalize({})
      assert.equals(0, vim.tbl_count(result))
    end)
  end)

  describe("table inputs", function()
    it("should handle plugin specs with config", function()
      local input = {
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "gitsigns.nvim", event = "BufRead" },
      }

      local result = normalize(input)

      assert.equals("nvim-treesitter/nvim-treesitter", result["nvim-treesitter/nvim-treesitter"][1])
      assert.equals(":TSUpdate", result["nvim-treesitter/nvim-treesitter"].build)
      assert.equals("BufRead", result["gitsigns.nvim"].event)
    end)

    it("should handle mixed strings and tables", function()
      local input = {
        "telescope.nvim",
        { "nvim-treesitter/nvim-treesitter", cmd = "TSUpdate" },
        "plenary.nvim",
      }

      local result = normalize(input)

      assert.equals("telescope.nvim", result["telescope.nvim"])
      assert.equals("TSUpdate", result["nvim-treesitter/nvim-treesitter"].cmd)
      assert.equals("plenary.nvim", result["plenary.nvim"])
    end)
  end)

  describe("single plugin spec", function()
    it("should handle a single spec with config keys", function()
      local input = {
        "telescope.nvim",
        cmd = "Telescope",
        event = "VeryLazy",
      }

      local result = normalize(input)

      assert.equals("telescope.nvim", result["telescope.nvim"][1])
      assert.equals("Telescope", result["telescope.nvim"].cmd)
      assert.equals("VeryLazy", result["telescope.nvim"].event)
    end)

    it("should handle a single spec with function values", function()
      local test_fn = function() return "test" end
      local input = {
        "telescope.nvim",
        cmd = "Telescope",
        config = test_fn,
      }

      local result = normalize(input)

      assert.equals("telescope.nvim", result["telescope.nvim"][1])
      assert.equals("Telescope", result["telescope.nvim"].cmd)
      assert.equals(test_fn, result["telescope.nvim"].config)
      assert.equals("function", type(result["telescope.nvim"].config))
    end)
  end)

  describe("error handling", function()
    it("should warn on table without [1] element", function()
      local warned = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.WARN and msg:match("missing a name") then
          warned = true
        end
      end

      local input = {
        { event = "BufRead" }, -- No [1]!
      }

      normalize(input)

      vim.notify = original_notify
      assert.is_true(warned)
    end)

    it("should warn on non-string [1] element", function()
      local warned = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.WARN and msg:match("invalid name type") then
          warned = true
        end
      end

      local input = {
        { 123, event = "BufRead" }, -- Number instead of string!
      }

      normalize(input)

      vim.notify = original_notify
      assert.is_true(warned)
    end)

    it("should warn on invalid input types", function()
      local warned = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.WARN and msg:match("invalid type") then
          warned = true
        end
      end

      local input = {
        123, -- Not a string or table!
      }

      normalize(input)

      vim.notify = original_notify
      assert.is_true(warned)
    end)

    it("should handle duplicate plugin names", function()
      local warned = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.WARN and msg:match("Duplicate plugin") then
          warned = true
        end
      end

      local input = {
        "telescope.nvim",
        { "telescope.nvim", cmd = "Telescope" },
      }

      local result = normalize(input)

      vim.notify = original_notify
      assert.is_true(warned)
      -- Should use the last definition
      assert.equals("Telescope", result["telescope.nvim"].cmd)
    end)
  end)

  describe("module loading", function()
    it("should load module by string name", function()
      -- Mock approach:
      local original_require = require
      _G.require = function(name)
        if name == "test_plugins" then
          return {
            "telescope.nvim",
            { "gitsigns.nvim", event = "BufRead" },
          }
        end
        return original_require(name)
      end

      local result = normalize("test_plugins")

      _G.require = original_require

      assert.equals("telescope.nvim", result["telescope.nvim"])
      assert.equals("BufRead", result["gitsigns.nvim"].event)
    end)

    it("should handle failed module require with error", function()
      local errored = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.ERROR and msg:match("Failed to load plugin module") then
          errored = true
        end
      end

      local result = normalize("nonexistent_module_xyz_123")

      vim.notify = original_notify
      assert.is_true(errored)
      assert.equals(0, vim.tbl_count(result))
    end)

    it("should error when module returns non-table", function()
      local errored = false
      local original_notify = vim.notify
      local original_require = require

      vim.notify = function(msg, level)
        if level == vim.log.levels.ERROR and msg:match("must return a table") then
          errored = true
        end
      end

      _G.require = function(name)
        if name == "bad_module" then
          return "not a table"
        end
        return original_require(name)
      end

      local result = normalize("bad_module")

      _G.require = original_require
      vim.notify = original_notify

      assert.is_true(errored)
      assert.equals(0, vim.tbl_count(result))
    end)
  end)

  describe("top-level input validation", function()
    it("should error on non-table, non-string input", function()
      local errored = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.ERROR and msg:match("expects a table or string") then
          errored = true
        end
      end

      local result = normalize(123)

      vim.notify = original_notify
      assert.is_true(errored)
      assert.equals(0, vim.tbl_count(result))
    end)

    it("should error on nil input", function()
      local errored = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.ERROR and msg:match("expects a table or string") then
          errored = true
        end
      end

      local result = normalize(nil)

      vim.notify = original_notify
      assert.is_true(errored)
      assert.equals(0, vim.tbl_count(result))
    end)
  end)
end)
