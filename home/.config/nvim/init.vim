set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Disables neovim python integration to speed up loading python files.
" Otherwise it takes forever to load these files.
"
" Alt option is to specify the python path. Eg:
"   let g:python3_host_prog = '/usr/bin/python3'
"
" Ref: https://neovim.io/doc/user/provider.html#g%3Apython3_host_prog
let g:loaded_python3_provider = 0

let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

source ~/.vimrc

" Add neovim specific plugins here from vim/pack/{label}/opt.
" This is necessary to avoid autolaoding these in standard vim.
" Which would happen in the vim/pack/{label}/start directory.
packadd plenary.nvim
packadd telescope.nvim
packadd nvim-treesitter
packadd lush.nvim

" make sure that all installed parsers are updated to the latest version via :TSUpdate
" TODO: make this not happen every load
TSUpdate

" required for lush colorschemes to work
set termguicolors

lua << EOF
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }

  -- Disable treesitter for help files since it cannot parse them correctly
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
      vim.treesitter.stop()
    end,
  })
EOF
