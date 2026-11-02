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
    'toml',
    'tsv',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
  },
  -- Parsers to never install or warn about, e.g. { 'bash' }
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

-- Set while the ensure_installed install pass kicked off at startup is still
-- running, so checks don't warn about parsers that are being installed right
-- now. Checked languages are memoized because the parser catalogs only change
-- on install or :TSUpdate; both reset when the install pass finishes.
local install_in_progress = false
local checked = {}

--- Attach highlighting to every open file buffer and return their filetypes
local function attach_open_buffers()
  local filetypes = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buftype == '' and vim.bo[bufnr].filetype ~= '' then
      pcall(vim.treesitter.start, bufnr)
      filetypes[#filetypes + 1] = vim.bo[bufnr].filetype
    end
  end

  return filetypes
end

function M.setup(_)
  -- Register aliased filetypes to parser languages (e.g. sh -> bash) up
  -- front, before nvim-treesitter loads, so treesitter consumers (like the
  -- ALE comment checks) work during startup.
  vim.treesitter.language.register('bash', 'sh')

  require('vim_4_eva.pack').lazy.register({
    'nvim-treesitter',
    event = 'DeferredUIEnter',
    after = function()
      -- Make sure that all installed parsers are updated to the latest
      -- version via :TSUpdate
      -- TODO: make this not happen every load possibly with some debouncing.
      --
      -- For now, just disabling and relying on manually running this.
      --
      -- vim.cmd.TSUpdate()

      -- Install missing parsers from ensure_installed (checks pause while
      -- the install pass runs)
      M.install_missing_parsers()

      -- Enable treesitter highlighting on file buffers.
      local highlight_group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = highlight_group,
        callback = function(args)
          -- vim.treesitter.start errors when the buffer has no parser
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Attach to buffers already open when the plugin loads
      attach_open_buffers()

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
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  })
end

--- Find missing treesitter parsers
--- @param languages table List of filetypes or languages to check
--- @param ignore_list table? List of languages to ignore
--- @return table List of missing parser language names
function M.find_missing_parsers(languages, ignore_list)
  local nvt = require('nvim-treesitter')
  local available = {}

  for _, lang in ipairs(nvt.get_available()) do
    available[lang] = true
  end

  local installed = {}

  for _, lang in ipairs(nvt.get_installed()) do
    installed[lang] = true
  end

  -- Create a set of ignored languages for fast lookup, resolving filetypes
  -- the same way as the languages below so an ignore entry like 'sh' also
  -- covers its parser language 'bash'
  local ignored = {}

  for _, lang in ipairs(ignore_list or {}) do
    local language = vim.treesitter.language.get_lang(lang) or lang
    ignored[language] = true
  end

  local missing = {}

  for _, lang in ipairs(languages) do
    -- Resolve filetype to parser language, e.g. sh -> bash
    local language = vim.treesitter.language.get_lang(lang) or lang

    -- Only report languages nvim-treesitter actually supports
    if available[language] and not ignored[language] and not installed[language] then
      table.insert(missing, language)
    end
  end

  return missing
end

--- Install missing parsers from ensure_installed, respecting ignore_install
--- (already installed parsers are skipped). Parser checks pause while the
--- install pass runs; when it finishes, open buffers are highlighted and
--- their parsers re-checked.
function M.install_missing_parsers()
  local missing = M.find_missing_parsers(M.ensure_installed, M.ignore_install)

  if #missing == 0 then
    return
  end

  install_in_progress = true

  -- install() runs async and returns a Task. Once it finishes, resume
  -- parser checks, then highlight and re-check buffers that were open
  -- while parsers were still building.
  require('nvim-treesitter').install(missing):await(function()
    install_in_progress = false
    checked = {}
    M.check_installed_parsers(attach_open_buffers(), M.ignore_install)
  end)
end

--- Check if required treesitter parsers are installed and warn about missing ones
--- @param languages table List of language parsers to check
--- @param ignore_list table? List of languages to ignore
function M.check_installed_parsers(languages, ignore_list)
  -- Don't warn about parsers that are installing right now
  if install_in_progress then
    return
  end

  -- Only check each language once; the parser catalogs only change on
  -- install or :TSUpdate. Resolve filetypes so aliases like 'sh' and 'bash'
  -- count as one language.
  local to_check = {}

  for _, lang in ipairs(languages) do
    local language = vim.treesitter.language.get_lang(lang) or lang

    if not checked[language] then
      checked[language] = true
      to_check[#to_check + 1] = language
    end
  end

  if #to_check == 0 then
    return
  end

  local missing = M.find_missing_parsers(to_check, ignore_list)

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
