local M = {}

function M.setup(_)
  -- Wrap vim.diagnostic.set to validate buffers before setting diagnostics
  -- This prevents "Invalid buffer id" errors when buffers are deleted during
  -- async linting (e.g., when backgrounding vim with ctrl-z)
  local original_diagnostic_set = vim.diagnostic.set
  vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
    -- Only proceed if buffer is valid
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      return original_diagnostic_set(namespace, bufnr, diagnostics, opts)
    end
  end

  -- Diagnostic Config
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.use_diagnotic_nerd_font_signs and {
      text = {
        [vim.diagnostic.severity.ERROR] = vim.g.vim_4_eva_diagnostic_sign_error or '󰅚 ',
        [vim.diagnostic.severity.WARN] = vim.g.vim_4_eva_diagnostic_sign_warning or '󰀪 ',
        [vim.diagnostic.severity.INFO] = vim.g.vim_4_eva_diagnostic_sign_info or '󰋽 ',
        [vim.diagnostic.severity.HINT] = vim.g.vim_4_eva_diagnostic_sign_hint or '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
  }
end

return M
