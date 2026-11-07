"-----------------------------------------------------------------------------
" spell language switcher
"-----------------------------------------------------------------------------
function! vim_4_eva#spell#SwitchLanguage() abort
  let l:lang = input('spelllang: ', &spelllang)
  if !empty(l:lang)
    let &l:spelllang = l:lang
  endif
endfunction
