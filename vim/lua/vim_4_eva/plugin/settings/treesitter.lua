local M = {
  ensure_installed = {
    'bash',
    'c',
    'c_sharp',
    'cpp',
    'csv',
    'cuda',
    'diff',
    'dockerfile',
    'editorconfig',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'gotmpl',
    'helm',
    'html',
    'lua',
    'luadoc',
    'java',
    'javadoc',
    'javascript',
    'jinja',
    'jinja_inline',
    'jq',
    'json',
    'make',
    'markdown',
    'markdown_inline',
    'mermaid',
    'perl',
    'python',
    'powershell',
    'query',
    'ruby',
    'rust',
    'terraform',
    'tmux',
    'toml',
    'tsv',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
  },
  ignore_install = {},
}

--- Notify helper that prefers fidget.notify if available
--- @param msg string The notification message
--- @param level number The log level (vim.log.levels.*)
--- @param opts table? Optional notification options
local function notify(msg, level, opts)
  local ok, fidget = pcall(require, 'fidget')

  if ok and fidget.notify then
    fidget.notify(msg, level, opts)
  else
    vim.notify(msg, level, opts)
  end
end

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'nvim-treesitter',
    event = 'DeferredUIEnter',
    after = function()
      -- Make sure that all installed parsers are updated to the latest version via :TSUpdate
      -- TODO: make this not happen every load possibly with some debouncing.
      --
      -- For now , just disabling and relying on manually running this.
      --
      -- Note that if enabled with auto_install=true this errors with using the same tmp dirs.
      --
      -- vim.cmd.TSUpdate()

      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or 'all' (the listed parsers MUST always be installed)
        ensure_installed = M.ensure_installed,

        -- Install parsers asynchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = false,

        -- List of parsers to ignore installing (or 'all')
        ignore_install = M.ignore_install,

        highlight = {
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      })

      -- Set up autocommand to check for missing parsers when opening files
      local augroup = vim.api.nvim_create_augroup('TreesitterParserCheck', { clear = true })

      -- Checks when file is openned
      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(args)
          -- Skip non-file buffers (help, quickfix, etc.)
          local buftype = vim.bo[args.buf].buftype

          if buftype ~= '' then
            return
          end

          M.check_installed_parsers({ args.match }, M.ignore_install)
        end,
      })

      -- Check current buffer if already loaded (handles CLI args like `vim foo.awk`)
      vim.schedule(function()
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype
        local buftype = vim.bo[bufnr].buftype

        if ft and ft ~= '' and buftype == '' then
          M.check_installed_parsers({ ft }, M.ignore_install)
        end
      end)
    end,

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  })
end

--- Find missing treesitter parsers
--- @param languages table List of language parsers to check
--- @param ignore_list table? List of languages to ignore
--- @return table List of missing parser names
function M.find_missing_parsers(languages, ignore_list)
  local parsers = require('nvim-treesitter.parsers')
  local parser_configs = parsers.get_parser_configs()
  local missing = {}
  local ignored = {}

  -- Create a set of ignored languages for fast lookup
  for _, lang in ipairs(ignore_list or {}) do
    ignored[lang] = true
  end

  for _, lang in ipairs(languages) do
    -- Only check if nvim-treesitter actually supports this language
    local is_supported = parser_configs[lang] ~= nil
    local has_parser = parsers.has_parser(lang)

    if is_supported and not ignored[lang] and not has_parser then
      table.insert(missing, lang)
    end
  end

  return missing
end

--- Check if required treesitter parsers are installed and warn about missing ones
--- @param languages table List of language parsers to check
--- @param ignore_list table? List of languages to ignore
function M.check_installed_parsers(languages, ignore_list)
  local missing = M.find_missing_parsers(languages, ignore_list)

  if #missing > 0 then
    notify(
      string.format(
        'Treesitter parsers not installed: %s\nRun :TSInstall %s',
        table.concat(missing, ', '),
        table.concat(missing, ' ')
      ),
      vim.log.levels.WARN,
      { title = 'nvim-treesitter' }
    )
  end
end

return M
