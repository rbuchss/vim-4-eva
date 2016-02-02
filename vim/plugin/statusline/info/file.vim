"-----------------------------------------------------------------------------
" fetch file size
"-----------------------------------------------------------------------------
nmap <silent> <leader>fs :echo 'filesize:' . FileSize()<CR>
function! FileSize()
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return ""
  endif
  if bytes < 1024
    return bytes
  else
    return (bytes / 1024) . "K"
  endif
endfunction
