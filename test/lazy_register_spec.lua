local pack = require('vim_4_eva.pack')

describe('lazy.register', function()
  -- Reset lazy.packages before each test to ensure clean state
  before_each(function()
    pack.lazy.packages = {}
  end)

  describe('basic registration', function()
    it('should register a list of plugin name strings', function()
      local input = {
        'telescope.nvim',
        'plenary.nvim',
      }

      pack.lazy.register(input)

      assert.are.same({
        ['telescope.nvim'] = { 'telescope.nvim' },
        ['plenary.nvim'] = { 'plenary.nvim' },
      }, pack.lazy.packages)
    end)

    it('should register plugin specs with config', function()
      local input = {
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        { 'gitsigns.nvim', event = 'BufRead' },
      }

      pack.lazy.register(input)

      assert.are.same({
        ['nvim-treesitter/nvim-treesitter'] = { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        ['gitsigns.nvim'] = { 'gitsigns.nvim', event = 'BufRead' },
      }, pack.lazy.packages)
    end)

    it('should register mixed strings and tables', function()
      local input = {
        'telescope.nvim',
        { 'nvim-treesitter/nvim-treesitter', cmd = 'TSUpdate' },
        'plenary.nvim',
      }

      pack.lazy.register(input)

      assert.are.same({
        ['telescope.nvim'] = { 'telescope.nvim' },
        ['nvim-treesitter/nvim-treesitter'] = { 'nvim-treesitter/nvim-treesitter', cmd = 'TSUpdate' },
        ['plenary.nvim'] = { 'plenary.nvim' },
      }, pack.lazy.packages)
    end)

    it('should register a single plugin spec with config keys', function()
      local input = {
        'telescope.nvim',
        cmd = 'Telescope',
        event = 'VeryLazy',
      }

      pack.lazy.register(input)

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          cmd = 'Telescope',
          event = 'VeryLazy',
        },
      }, pack.lazy.packages)
    end)

    it('should register a single spec with function values', function()
      local test_fn = function() return 'test' end
      local input = {
        'telescope.nvim',
        cmd = 'Telescope',
        config = test_fn,
      }

      pack.lazy.register(input)

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          cmd = 'Telescope',
          config = test_fn,
        },
      }, pack.lazy.packages)
    end)
  end)

  describe('merging behavior', function()
    it('should merge configs with same plugin name', function()
      pack.lazy.register({
        { 'telescope.nvim', cmd = 'Telescope' },
      })
      pack.lazy.register({
        { 'telescope.nvim', event = 'VeryLazy' },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          cmd = 'Telescope',
          event = 'VeryLazy',
        },
      }, pack.lazy.packages)
    end)

    it('should override config values on conflict', function()
      pack.lazy.register({
        { 'telescope.nvim', cmd = 'Telescope', priority = 100 },
      })
      pack.lazy.register({
        { 'telescope.nvim', priority = 200, event = 'VeryLazy' },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          cmd = 'Telescope',
          priority = 200, -- Should be overridden
          event = 'VeryLazy',
        },
      }, pack.lazy.packages)
    end)

    it('should merge nested tables', function()
      pack.lazy.register({
        { 'telescope.nvim', opts = { theme = 'dropdown' } },
      })
      pack.lazy.register({
        { 'telescope.nvim', opts = { hidden = true } },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          opts = { theme = 'dropdown', hidden = true },
        },
      }, pack.lazy.packages)
    end)

    it('should merge multiple plugins in a single call', function()
      pack.lazy.register({
        { 'telescope.nvim', cmd = 'Telescope' },
      })
      pack.lazy.register({
        { 'telescope.nvim', event = 'VeryLazy' },
        { 'plenary.nvim', lazy = true },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          cmd = 'Telescope',
          event = 'VeryLazy',
        },
        ['plenary.nvim'] = {
          'plenary.nvim',
          lazy = true,
        },
      }, pack.lazy.packages)
    end)

    it('should handle merging with string-only initial registration', function()
      pack.lazy.register({ 'telescope.nvim' })
      pack.lazy.register({
        { 'telescope.nvim', cmd = 'Telescope', event = 'VeryLazy' },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          cmd = 'Telescope',
          event = 'VeryLazy',
        },
      }, pack.lazy.packages)
    end)

    it('should merge function values correctly', function()
      local fn1 = function() return 'first' end
      local fn2 = function() return 'second' end

      pack.lazy.register({
        { 'telescope.nvim', config = fn1 },
      })
      pack.lazy.register({
        { 'telescope.nvim', init = fn2 },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          config = fn1,
          init = fn2,
        },
      }, pack.lazy.packages)
    end)

    it('should override function values on conflict', function()
      local fn1 = function() return 'first' end
      local fn2 = function() return 'second' end

      pack.lazy.register({
        { 'telescope.nvim', config = fn1 },
      })
      pack.lazy.register({
        { 'telescope.nvim', config = fn2 },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          config = fn2,
        },
      }, pack.lazy.packages)
    end)
  end)

  describe('module loading', function()
    it('should load module by string name', function()
      local original_require = require
      _G.require = function(name)
        if name == 'test_plugins' then
          return {
            'telescope.nvim',
            { 'gitsigns.nvim', event = 'BufRead' },
          }
        end
        return original_require(name)
      end

      pack.lazy.register('test_plugins')

      _G.require = original_require

      assert.are.same({
        ['telescope.nvim'] = { 'telescope.nvim' },
        ['gitsigns.nvim'] = { 'gitsigns.nvim', event = 'BufRead' },
      }, pack.lazy.packages)
    end)

    it('should handle failed module require with error', function()
      local errored = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.ERROR and msg:match('Failed to load plugin module') then
          errored = true
        end
      end

      pack.lazy.register('nonexistent_module_xyz_123')

      vim.notify = original_notify
      assert.is_true(errored)
      assert.are.same({}, pack.lazy.packages)
    end)
  end)

  describe('empty and edge cases', function()
    it('should handle empty list', function()
      pack.lazy.register({})
      assert.are.same({}, pack.lazy.packages)
    end)

    it('should handle multiple registrations with empty state', function()
      pack.lazy.register({ 'telescope.nvim' })
      assert.are.same({
        ['telescope.nvim'] = { 'telescope.nvim' },
      }, pack.lazy.packages)

      pack.lazy.register({})
      assert.are.same({
        ['telescope.nvim'] = { 'telescope.nvim' },
      }, pack.lazy.packages)
    end)

    it('should preserve existing registrations when adding new ones', function()
      pack.lazy.register({ 'telescope.nvim' })
      pack.lazy.register({ 'plenary.nvim' })

      assert.are.same({
        ['telescope.nvim'] = { 'telescope.nvim' },
        ['plenary.nvim'] = { 'plenary.nvim' },
      }, pack.lazy.packages)
    end)
  end)

  describe('complex merging scenarios', function()
    it('should merge array-like config values', function()
      pack.lazy.register({
        { 'telescope.nvim', dependencies = { 'plenary.nvim' } },
      })
      pack.lazy.register({
        { 'telescope.nvim', dependencies = { 'nvim-web-devicons' } },
      })

      -- vim.tbl_deep_extend with 'force' will override arrays
      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          dependencies = { 'nvim-web-devicons' },
        },
      }, pack.lazy.packages)
    end)

    it('should handle deeply nested table merging', function()
      pack.lazy.register({
        { 'telescope.nvim', opts = { defaults = { layout_config = { width = 0.8 } } } },
      })
      pack.lazy.register({
        { 'telescope.nvim', opts = { defaults = { layout_config = { height = 0.9 } } } },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          opts = {
            defaults = {
              layout_config = {
                width = 0.8,
                height = 0.9,
              },
            },
          },
        },
      }, pack.lazy.packages)
    end)

    it('should merge multiple plugins across multiple registrations', function()
      pack.lazy.register({
        { 'telescope.nvim', cmd = 'Telescope' },
        { 'gitsigns.nvim', event = 'BufRead' },
      })
      pack.lazy.register({
        { 'telescope.nvim', event = 'VeryLazy' },
        { 'plenary.nvim', lazy = false },
      })
      pack.lazy.register({
        { 'gitsigns.nvim', cmd = 'Gitsigns' },
      })

      assert.are.same({
        ['telescope.nvim'] = {
          'telescope.nvim',
          cmd = 'Telescope',
          event = 'VeryLazy',
        },
        ['gitsigns.nvim'] = {
          'gitsigns.nvim',
          event = 'BufRead',
          cmd = 'Gitsigns',
        },
        ['plenary.nvim'] = {
          'plenary.nvim',
          lazy = false,
        },
      }, pack.lazy.packages)
    end)
  end)

  describe('integration with lazy.normalize', function()
    it('should handle all input types supported by lazy.normalize', function()
      pack.lazy.register({ 'telescope.nvim' })
      pack.lazy.register({
        { 'gitsigns.nvim', event = 'BufRead' },
      })
      pack.lazy.register({
        'plenary.nvim',
        cmd = 'Plenary',
      })

      assert.are.same({
        ['telescope.nvim'] = { 'telescope.nvim' },
        ['gitsigns.nvim'] = {
          'gitsigns.nvim',
          event = 'BufRead',
        },
        ['plenary.nvim'] = {
          'plenary.nvim',
          cmd = 'Plenary',
        },
      }, pack.lazy.packages)
    end)

    it('should warn on invalid inputs like lazy.normalize', function()
      local warned = false
      local original_notify = vim.notify
      vim.notify = function(msg, level)
        if level == vim.log.levels.WARN and msg:match('missing a name') then
          warned = true
        end
      end

      pack.lazy.register({
        { event = 'BufRead' }, -- No [1]!
      })

      vim.notify = original_notify
      assert.is_true(warned)
    end)
  end)
end)
