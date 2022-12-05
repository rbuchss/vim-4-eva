function! GitStatusline()
  let status = fugitive#head(7)
  if empty(status)
    return ''
  else
    return '  '.status.':'
  endif
endfunction
