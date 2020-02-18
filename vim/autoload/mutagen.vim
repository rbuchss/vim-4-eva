if exists("g:loaded_mutagen") || &cp
  finish
endif
let g:loaded_mutagen = 1

function! mutagen#infect(...) abort " {{{1
  call mutagen#set_os()
  call mutagen#set_vim_home()
  return ''
endfunction " }}}1

function! mutagen#mutate(...) abort " {{{1
  call mutagen#load_os_settings()
  return ''
endfunction " }}}1

function! mutagen#get_os(...) abort " {{{1
  if has('win16') || has('win32') || has('win64') || has('win32unix')
    return 'windows'
  else
    let l:uname = substitute(system('uname'), '\n', '', '')

    if l:uname == "Darwin"
      return 'darwin'
    elseif l:uname == 'Linux'
      return 'linux'
    elseif l:uname =~ '\v^(MINGW64_NT|MINGW32_NT)'
     return 'windows'
    endif
  endif

  return ''
endfunction " }}}1

function! mutagen#set_os(...) abort " {{{1
  let g:mutagen_os = mutagen#get_os()
  return ''
endfunction " }}}1

function! mutagen#get_vim_home(...) abort " {{{1
  if g:mutagen_os == 'windows'
    return $HOME . '/vimfiles'
  else
    return $HOME . '/.vim'
  endif
  return ''
endfunction " }}}1

function! mutagen#set_vim_home(...) abort " {{{1
  let g:mutagen_os_vim_home = mutagen#get_vim_home()
  return ''
endfunction " }}}1

function! mutagen#load_os_settings(...) abort " {{{1
  execute 'source' g:mutagen_os_vim_home . '/os/' . g:mutagen_os . '/settings.vim'
  return ''
endfunction " }}}1
