local M = {}

function M.setup(_)
  require('vim_4_eva.pack').lazy.register({
    {
      'claude-code.nvim',
      cmd = {
        'ClaudeCode',
        'ClaudeCodeContinue',
        'ClaudeCodeResume',
        'ClaudeCodeVerbose',
      },
      keys = {
        {
          '<leader>aa',
          desc = 'Claude Code: Toggle',
          mode =  { 'n', 't' },
        },
        {
          '<leader>aC',
          desc = 'Claude Code: Continue',
          mode = 'n',
        },
        {
          '<leader>aV',
          desc = 'Claude Code: Continue',
          mode = 'n',
        },
      },
      before = function()
        require('lz.n').trigger_load('plenary.nvim')
      end,
      after = function()
        require('claude-code').setup({
          window = {
            position = 'float',
            float = {
              width = '90%',      -- Take up 90% of the editor width
              height = '90%',     -- Take up 90% of the editor height
              row = 'center',
              col = 'center',
              relative = 'editor',
              border = 'rounded',
            },
          },
          keymaps = {
            toggle = {
              normal = '<leader>aa',       -- Normal mode keymap for toggling Claude Code, false to disable
              terminal = '<leader>aa',     -- Terminal mode keymap for toggling Claude Code, false to disable
              variants = {
                continue = '<leader>aC', -- Normal mode keymap for Claude Code with continue flag
                verbose = '<leader>aV',  -- Normal mode keymap for Claude Code with verbose flag
              },
            },
            window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
            scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
          },
        })
      end
    },
  })
end

return M
