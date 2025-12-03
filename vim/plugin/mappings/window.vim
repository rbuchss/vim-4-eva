" Keybinds to make split navigation easier.
"  Use CTRL+<hjkl> to switch between windows
"
"  See `:help wincmd` for a list of all window commands
"
noremap <C-h> :wincmd h<CR>
noremap <C-j> :wincmd j<CR>
noremap <C-k> :wincmd k<CR>
noremap <C-l> :wincmd l<CR>

noremap <C-Left> :wincmd h<CR>
noremap <C-Down> :wincmd j<CR>
noremap <C-Up> :wincmd k<CR>
noremap <C-Right> :wincmd l<CR>

" NOTE: Some terminals have colliding keymaps or are not
" able to send distinct keycodes
noremap <M-C-h> :wincmd H<CR>
noremap <M-C-j> :wincmd J<CR>
noremap <M-C-k> :wincmd K<CR>
noremap <M-C-l> :wincmd L<CR>

noremap <M-C-Left> :wincmd H<CR>
noremap <M-C-Down> :wincmd J<CR>
noremap <M-C-Up> :wincmd K<CR>
noremap <M-C-Right> :wincmd L<CR>

" toggle line wrap
noremap <leader>wt :setlocal wrap!<CR>
