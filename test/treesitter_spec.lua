describe('treesitter', function()
  local treesitter
  local mock_parsers
  local original_notify

  before_each(function()
    -- Reset module cache
    package.loaded['vim_4_eva.plugin.settings.treesitter'] = nil
    package.loaded['nvim-treesitter.parsers'] = nil

    -- Mock nvim-treesitter.parsers module
    mock_parsers = {
      get_parser_configs = function()
        return {
          lua = { install_info = {} },
          python = { install_info = {} },
          javascript = { install_info = {} },
          rust = { install_info = {} },
          awk = { install_info = {} },
        }
      end,
      has_parser = function(lang)
        -- Default: all parsers are missing
        return false
      end,
    }

    package.preload['nvim-treesitter.parsers'] = function()
      return mock_parsers
    end

    -- Save original vim.notify
    original_notify = vim.notify
    vim.notify = function() end  -- stub out notifications

    -- Load treesitter module
    treesitter = require('vim_4_eva.plugin.settings.treesitter')
  end)

  after_each(function()
    -- Restore vim.notify
    vim.notify = original_notify

    -- Clean up preloaded modules
    package.preload['nvim-treesitter.parsers'] = nil
    package.loaded['nvim-treesitter.parsers'] = nil
  end)

  describe('find_missing_parsers', function()
    it('should return empty list when all parsers are installed', function()
      mock_parsers.has_parser = function()
        return true
      end

      local missing = treesitter.find_missing_parsers({ 'lua', 'python' }, {})

      assert.are.same({}, missing)
    end)

    it('should return missing parsers', function()
      mock_parsers.has_parser = function()
        return false
      end

      local missing = treesitter.find_missing_parsers({ 'lua', 'python' }, {})

      assert.are.same({ 'lua', 'python' }, missing)
    end)

    it('should exclude ignored parsers', function()
      mock_parsers.has_parser = function()
        return false
      end

      local missing = treesitter.find_missing_parsers({ 'lua', 'python' }, { 'python' })

      assert.are.same({ 'lua' }, missing)
    end)

    it('should exclude unsupported languages', function()
      mock_parsers.has_parser = function()
        return false
      end

      local missing = treesitter.find_missing_parsers({ 'unsupported-language' }, {})

      assert.are.same({}, missing)
    end)

    it('should handle mixed installed and missing parsers', function()
      mock_parsers.has_parser = function(lang)
        if lang == 'lua' or lang == 'rust' then
          return true
        end
        return false
      end

      local missing = treesitter.find_missing_parsers({ 'lua', 'python', 'rust' }, {})

      assert.are.same({ 'python' }, missing)
    end)

    it('should handle empty language list', function()
      local missing = treesitter.find_missing_parsers({}, {})

      assert.are.same({}, missing)
    end)

    it('should handle nil ignore_list', function()
      mock_parsers.has_parser = function()
        return false
      end

      local missing = treesitter.find_missing_parsers({ 'lua' }, nil)

      assert.are.same({ 'lua' }, missing)
    end)

    it('should only include supported and not ignored languages', function()
      mock_parsers.has_parser = function()
        return false
      end

      local missing = treesitter.find_missing_parsers(
        { 'lua', 'unsupported', 'python', 'rust' },
        { 'rust' }
      )

      assert.are.same({ 'lua', 'python' }, missing)
    end)
  end)

  describe('check_installed_parsers', function()
    it('should not notify when no parsers are missing', function()
      local notified = false
      vim.notify = function()
        notified = true
      end

      mock_parsers.has_parser = function()
        return true
      end

      treesitter.check_installed_parsers({ 'lua', 'python' }, {})

      assert.is_false(notified)
    end)

    it('should notify when parsers are missing', function()
      local notify_args = nil
      vim.notify = function(msg, level, opts)
        notify_args = { msg = msg, level = level, opts = opts }
      end

      mock_parsers.has_parser = function()
        return false
      end

      treesitter.check_installed_parsers({ 'lua', 'python' }, {})

      assert.is_not_nil(notify_args)
      assert.is_not_nil(notify_args.msg:match('lua'))
      assert.is_not_nil(notify_args.msg:match('python'))
      assert.equals(vim.log.levels.WARN, notify_args.level)
    end)

    it('should include TSInstall command in notification', function()
      local notify_args = nil
      vim.notify = function(msg, level, opts)
        notify_args = { msg = msg, level = level, opts = opts }
      end

      mock_parsers.has_parser = function()
        return false
      end

      treesitter.check_installed_parsers({ 'awk' }, {})

      assert.is_not_nil(notify_args)
      assert.is_not_nil(notify_args.msg:match('TSInstall'))
      assert.is_not_nil(notify_args.msg:match('awk'))
    end)

    it('should include title in notification options', function()
      local notify_args = nil
      vim.notify = function(msg, level, opts)
        notify_args = { msg = msg, level = level, opts = opts }
      end

      mock_parsers.has_parser = function()
        return false
      end

      treesitter.check_installed_parsers({ 'lua' }, {})

      assert.is_not_nil(notify_args)
      assert.equals('nvim-treesitter', notify_args.opts.title)
    end)
  end)
end)
