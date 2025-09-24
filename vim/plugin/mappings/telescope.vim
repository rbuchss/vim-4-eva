if has('nvim')
  " Find files using Telescope command-line sugar.
  nnoremap <leader>ff <cmd>Telescope find_files<CR>
  nnoremap <leader>fg <cmd>Telescope live_grep<CR>
  nnoremap <leader>fc <cmd>Telescope grep_string<CR>
  nnoremap <leader>fb <cmd>Telescope buffers<CR>
  nnoremap <leader>fh <cmd>Telescope help_tags<CR>
  nnoremap <leader>fm <cmd>Telescope marks<CR>
else
  nnoremap <leader>ff :echo "Telescope requires Neovim"<CR>
  nnoremap <leader>fg :echo "Telescope requires Neovim"<CR>
  nnoremap <leader>fc :echo "Telescope requires Neovim"<CR>
  nnoremap <leader>fb :echo "Telescope requires Neovim"<CR>
  nnoremap <leader>fh :echo "Telescope requires Neovim"<CR>
  nnoremap <leader>fm :echo "Telescope requires Neovim"<CR>
endif
