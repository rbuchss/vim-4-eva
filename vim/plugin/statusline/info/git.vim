function! GitStatusline(len = 7)
  " Get either branch name or commit id with full 40 bytes
  let head = fugitive#head(-1)
  if empty(head)
    return ''
  elseif head =~# '^\x\{40,\}$'
    let content = a:len < 0 ? head : strpart(head, 0, a:len).'...'
    return '  ('.content.')'
  else
    return ' '.head
  endif
endfunction
