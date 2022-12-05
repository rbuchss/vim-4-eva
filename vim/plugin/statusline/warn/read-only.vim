"-----------------------------------------------------------------------------
" read only flag setter
"-----------------------------------------------------------------------------
function! ReadOnlyFlag()
  " TODO fix this icon
  return &ft !~? 'vimfiler\|gundo' && &readonly ? '[⭤]' : ''
endfunction
