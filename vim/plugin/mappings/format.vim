" removes all trailing whitespace
" '<leader>sw' is telescope's search current word on nvim, so this takes the
" format prefix instead
nmap <leader>fw :call vim_4_eva#format#StripTrailingWhitespace()<CR>

" Don't use Ex mode, use Q for formatting
map Q gq
