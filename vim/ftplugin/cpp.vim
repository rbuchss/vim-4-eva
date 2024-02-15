" comments default: s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-"
set comments=sl:/**,mb:\ *,elx:\ */

" Does not work unless in the same dir eg. include and src dirs...
" map <F6> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

nmap <leader>rt :!clear && make test<CR>
nmap <leader>rc :!clear && make coverage<CR>
