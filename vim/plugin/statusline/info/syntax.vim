"-----------------------------------------------------------------------------
" return the syntax highlight group under the cursor ''
"-----------------------------------------------------------------------------
" Returns syntax highlighting group the current "thing" under the cursor
nmap <silent> ,qq :echo 'stack' . StatuslineCurrentSynStack() .
      \ ' hi' . StatuslineCurrentHighlight() .
      \ ' trans' . StatuslineCurrentTrans() .
      \ ' lo' . StatuslineCurrentLo() <CR>

function! StatuslineCurrentHighlight()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentTrans()
  let name = synIDattr(synID(line('.'),col('.'),0),"name")
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentLo()
  let name = synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentSynStack()
  if !exists("*synstack")
    return
  endif
  let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  return '[' . join(stack, ', ') . ']'
endfunc
