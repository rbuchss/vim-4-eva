local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    'conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fb',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat [B]uffer',
      },
    },
    after = function()
      require('conform').setup({
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable 'format_on_save lsp_fallback' for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = {}

          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            return {
              timeout_ms = 500,
              lsp_format = 'fallback',
            }
          end
        end,
        formatters_by_ft = {
          bash = { 'shfmt' },
          c = { 'clang-format' },
          cpp = { 'clang-format' },
          cuda = { 'clang-format' },
          go = { 'goimports', 'gofmt' },
          -- You can use 'stop_after_first' to run the first available formatter from the list
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
          lua = { 'stylua' },
          markdown = { 'markdownlint' },
          -- Conform can also run multiple formatters sequentially
          python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
          -- You can also customize some of the format options for the filetype
          rust = { 'rustfmt', lsp_format = 'fallback' },
          sh = { 'shfmt' },
          yaml = { 'yamlfmt' },
        },
      })
    end,
  })
end

return M
