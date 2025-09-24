"-----------------------------------------------------------------------------
" whitespace nuker
"-----------------------------------------------------------------------------
function! vim_4_eva#format#StripTrailingWhitespace() abort
  call vim_4_eva#util#Preserve("%s/\\s\\+$//e")
endfunction
