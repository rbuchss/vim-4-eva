let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" https://medium.com/@Sohjiro/setup-vim-checkstyle-java-d0dd74dca1e1
" syntastic uses system command with windows back-slashes which appears
" to make java checks go off the rails...
let g:syntastic_java_checkers = []

" http://c-j-j.github.io/vim/2015/03/25/vim-with-c-sharp.html
" stops csproj 'no DTD found' error
let g:syntastic_cs_checkers = []
