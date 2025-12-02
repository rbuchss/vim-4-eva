" This allows for change paste motion cp{motion}
" so replace word with current buffer would be cpw
" 3 words would be cp3w
" rest of line would be cp$ and so on...
nmap <silent> cp :set opfunc=vim_4_eva#motion#ChangePaste<CR>g@

" " Mac OS X clipboard integration
" nmap <F3> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
" vmap <F4> :w !pbcopy<CR><CR>

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
