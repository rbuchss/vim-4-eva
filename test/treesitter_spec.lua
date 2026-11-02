describe('treesitter', function()
  local treesitter
  local mock_nvt
  local original_notify
  local original_get_lang

  before_each(function()
    -- Reset module cache
    package.loaded['vim_4_eva.plugin.settings.treesitter'] = nil
    package.loaded['nvim-treesitter'] = nil

    -- Mock nvim-treesitter module
    mock_nvt = {
      get_available = function()
        return {
          'lua',
          'python',
          'javascript',
          'rust',
          'awk',
          'bash',
        }
      end,
      get_installed = function()
        -- Default: all parsers are missing
        return {}
      end,
    }

    package.preload['nvim-treesitter'] = function()
      return mock_nvt
    end

    -- Stub filetype -> language resolution (identity by default)
    original_get_lang = vim.treesitter.language.get_lang
    vim.treesitter.language.get_lang = function(ft)
      return ft
    end

    -- Save original vim.notify
    original_notify = vim.notify
    vim.notify = function() end  -- stub out notifications

    -- Load treesitter module
    treesitter = require('vim_4_eva.plugin.settings.treesitter')
  end)

  after_each(function()
    -- Restore vim.notify and get_lang
    vim.notify = original_notify
    vim.treesitter.language.get_lang = original_get_lang

    -- Clean up preloaded modules
    package.preload['nvim-treesitter'] = nil
    package.loaded['nvim-treesitter'] = nil
  end)

  describe('find_missing_parsers', function()
    it('should return empty list when all parsers are installed', function()
      mock_nvt.get_installed = function()
        return { 'lua', 'python' }
      end

      local missing = treesitter.find_missing_parsers({ 'lua', 'python' }, {})

      assert.are.same({}, missing)
    end)

    it('should return missing parsers', function()
      local missing = treesitter.find_missing_parsers({ 'lua', 'python' }, {})

      assert.are.same({ 'lua', 'python' }, missing)
    end)

    it('should exclude ignored parsers', function()
      local missing = treesitter.find_missing_parsers({ 'lua', 'python' }, { 'python' })

      assert.are.same({ 'lua' }, missing)
    end)

    it('should exclude unsupported languages', function()
      local missing = treesitter.find_missing_parsers({ 'unsupported-language' }, {})

      assert.are.same({}, missing)
    end)

    it('should handle mixed installed and missing parsers', function()
      mock_nvt.get_installed = function()
        return { 'lua', 'rust' }
      end

      local missing = treesitter.find_missing_parsers({ 'lua', 'python', 'rust' }, {})

      assert.are.same({ 'python' }, missing)
    end)

    it('should handle empty language list', function()
      local missing = treesitter.find_missing_parsers({}, {})

      assert.are.same({}, missing)
    end)

    it('should handle nil ignore_list', function()
      local missing = treesitter.find_missing_parsers({ 'lua' }, nil)

      assert.are.same({ 'lua' }, missing)
    end)

    it('should only include supported and not ignored languages', function()
      local missing = treesitter.find_missing_parsers(
        { 'lua', 'unsupported', 'python', 'rust' },
        { 'rust' }
      )

      assert.are.same({ 'lua', 'python' }, missing)
    end)

    it('should resolve filetype aliases to parser languages', function()
      vim.treesitter.language.get_lang = function(ft)
        if ft == 'sh' then
          return 'bash'
        end
        return ft
      end

      local missing = treesitter.find_missing_parsers({ 'sh' }, {})

      assert.are.same({ 'bash' }, missing)
    end)

    it('should not report aliased filetypes with installed parsers', function()
      vim.treesitter.language.get_lang = function(ft)
        if ft == 'sh' then
          return 'bash'
        end
        return ft
      end

      mock_nvt.get_installed = function()
        return { 'bash' }
      end

      local missing = treesitter.find_missing_parsers({ 'sh' }, {})

      assert.are.same({}, missing)
    end)

    it('should exclude ignored filetypes resolved to parser languages', function()
      vim.treesitter.language.get_lang = function(ft)
        if ft == 'sh' then
          return 'bash'
        end
        return ft
      end

      local missing = treesitter.find_missing_parsers({ 'sh' }, { 'sh' })

      assert.are.same({}, missing)
    end)
  end)

  describe('install_missing_parsers', function()
    it('should install missing parsers excluding ignored and unsupported', function()
      vim.treesitter.language.get_lang = function(ft)
        if ft == 'sh' then
          return 'bash'
        end
        return ft
      end

      treesitter.ensure_installed = { 'lua', 'python', 'awk', 'sh', 'unsupported' }
      treesitter.ignore_install = { 'python' }

      local install_args = nil
      mock_nvt.install = function(langs)
        install_args = langs
        return { await = function() end }
      end

      treesitter.install_missing_parsers()

      assert.are.same({ 'lua', 'awk', 'bash' }, install_args)
    end)

    it('should not install when nothing is missing', function()
      treesitter.ensure_installed = { 'lua' }
      mock_nvt.get_installed = function()
        return { 'lua' }
      end

      local called = false
      mock_nvt.install = function()
        called = true
      end

      treesitter.install_missing_parsers()

      assert.is_false(called)
    end)

    it('should pause checks during the install pass and re-check after it finishes', function()
      treesitter.ensure_installed = { 'awk' }

      local completion = nil
      mock_nvt.install = function()
        return {
          await = function(_, cb)
            completion = cb
          end,
        }
      end

      local warnings = {}
      vim.notify = function(msg)
        warnings[#warnings + 1] = msg
      end

      local function awk_warnings()
        local count = 0
        for _, msg in ipairs(warnings) do
          if msg:match('awk') then
            count = count + 1
          end
        end
        return count
      end

      -- Warns and memoizes awk before the install pass starts
      treesitter.check_installed_parsers({ 'awk' }, {})
      assert.equals(1, awk_warnings())

      treesitter.install_missing_parsers()

      -- While the install pass runs, checks pause
      treesitter.check_installed_parsers({ 'awk' }, {})
      assert.equals(1, awk_warnings())

      completion()

      -- After it finishes, the memo reset lets awk warn again
      treesitter.check_installed_parsers({ 'awk' }, {})
      assert.equals(2, awk_warnings())
    end)
  end)

  describe('check_installed_parsers', function()
    it('should not notify when no parsers are missing', function()
      local notified = false
      vim.notify = function()
        notified = true
      end

      mock_nvt.get_installed = function()
        return { 'lua', 'python' }
      end

      treesitter.check_installed_parsers({ 'lua', 'python' }, {})

      assert.is_false(notified)
    end)

    it('should notify when parsers are missing', function()
      local notify_args = nil
      vim.notify = function(msg, level, opts)
        notify_args = { msg = msg, level = level, opts = opts }
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

      treesitter.check_installed_parsers({ 'lua' }, {})

      assert.is_not_nil(notify_args)
      assert.equals('nvim-treesitter', notify_args.opts.title)
    end)

    it('should only notify once per language', function()
      local notify_count = 0
      vim.notify = function()
        notify_count = notify_count + 1
      end

      treesitter.check_installed_parsers({ 'awk' }, {})
      treesitter.check_installed_parsers({ 'awk' }, {})
      treesitter.check_installed_parsers({ 'awk' }, {})

      assert.equals(1, notify_count)
    end)

    it('should only notify once per resolved language', function()
      vim.treesitter.language.get_lang = function(ft)
        if ft == 'sh' then
          return 'bash'
        end
        return ft
      end

      local notify_count = 0
      vim.notify = function()
        notify_count = notify_count + 1
      end

      treesitter.check_installed_parsers({ 'sh' }, {})
      treesitter.check_installed_parsers({ 'bash' }, {})

      assert.equals(1, notify_count)
    end)
  end)
end)
