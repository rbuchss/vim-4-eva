"-----------------------------------------------------------------------------
" read only flag setter
"-----------------------------------------------------------------------------
function! ReadOnlyFlag()
  return &ft !~? 'vimfiler\|gundo' && &readonly ? '[🔒]' : ''
endfunction
