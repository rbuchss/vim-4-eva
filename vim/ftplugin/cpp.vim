" https://stackoverflow.com/questions/18158772/how-to-add-c11-support-to-syntastic-vim-plugin
"
" see: vim/bundle/syntastic/syntax_checkers/cpp/gcc.vim
"
" let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_check_header = 1
" let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

" comments default: s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-"
set comments=sl:/**,mb:\ *,elx:\ */

" Does not work unless in the same dir eg. include and src dirs...
" map <F6> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

nmap <leader>rt :!clear && make test<CR>
nmap <leader>rc :!clear && make coverage<CR>
