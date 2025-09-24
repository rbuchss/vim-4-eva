function! vim_4_eva#syntax#CurrentHighlight()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! vim_4_eva#syntax#CurrentTrans()
  let name = synIDattr(synID(line('.'),col('.'),0),"name")
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! vim_4_eva#syntax#CurrentLo()
  let name = synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! vim_4_eva#syntax#CurrentSynStack()
  if !exists("*synstack")
    return
  endif
  let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  return '[' . join(stack, ', ') . ']'
endfunc
