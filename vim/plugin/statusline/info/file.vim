"-----------------------------------------------------------------------------
" fetch file size
"-----------------------------------------------------------------------------
nmap <silent> <leader>fs :echo 'filesize:' . FileSize()<CR>

function! FileSize()
  let fn = expand("%:p")
  let bytes = getfsize(fn)
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

function! StatusLineFileName()
  let pre = ''
  let pat = '://'
" NOTE: execute 'let start = reltime() | echo expand("%:~:.") | echo "time: "reltimestr(reltime(start)) '
"  is there a way to cache this???
  let name = expand('%:~:.')
  if name =~# pat
    let pre = name[:stridx(name, pat) + len(pat)-1] . '...'
    let name = name[stridx(name, pat) + len(pat):]
  endif
  let name = simplify(name)
  let ratio = (1.0 * winwidth(0)) / len(name)
  if ratio <= 2 && ratio > 1.5
    let name = pathshorten(name)
  elseif ratio <= 1.5
    let name = fnamemodify(name, ':t')
  endif
  return pre . name
endfunction
