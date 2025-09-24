" ctags helpers
" from https://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks
" map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" map <M-]> :vsplit <CR>:exec("tag ".expand("<cword>"))<CR>
map <M-]>t :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <M-]>v :vsplit <CR>:exec("tag ".expand("<cword>"))<CR>
map <M-]>s :split <CR>:exec("tag ".expand("<cword>"))<CR>
