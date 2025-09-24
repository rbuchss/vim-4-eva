" tab shortcuts
map <leader>tn :tabnew<CR>
map <leader>tc :tabclose<CR>

if has('nvim')
    map <M-Right> :tabn<CR>
    map <M-Left> :tabp<CR>
else
    map <T-Right> :tabn<CR>
    map <T-Left> :tabp<CR>
endif

" fix for osx option-command chord in tmux 2.1
" used `sed -n l` to find the chord key code
map <ESC>[1;3C :tabn<CR>
map <ESC>[1;3D :tabp<CR>
