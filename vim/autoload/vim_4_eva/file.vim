function! vim_4_eva#file#Size() abort
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return "empty"
  elseif bytes > 0 && bytes < 1024
    return bytes . "B"
  elseif (bytes >= 1024) && (bytes < pow(1024, 2))
    return printf('%.2fK', (bytes / 1024.0))
  elseif (bytes >= pow(1024, 2)) && (bytes < pow(1024, 3))
    return printf('%.2fM', (bytes / pow(1024.0, 2)))
  else
    return printf('%.2fG', (bytes / pow(1024.0, 3)))
  endif
endfunction
