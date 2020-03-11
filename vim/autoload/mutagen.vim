if exists("g:loaded_mutagen") || &cp
  finish
endif
let g:loaded_mutagen = 1

function! mutagen#infect(...) abort
  return ''
endfunction

function! mutagen#mutate() abort
  return mutagen#load_os_settings()
endfunction

function! mutagen#derive_os() abort
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
endfunction

function! mutagen#os() abort
  if exists("g:mutagen_os")
    return g:mutagen_os
  endif

  let g:mutagen_os = mutagen#derive_os()
  return g:mutagen_os
endfunction

function! mutagen#is_os(name) abort
  return mutagen#os() == a:name
endfunction

function! mutagen#derive_vim_home() abort
  if mutagen#is_os('windows')
    return $HOME . '/vimfiles'
  elseif mutagen#is_os('darwin') || mutagen#is_os('linux')
    return $HOME . '/.vim'
  endif
  return ''
endfunction

function! mutagen#vim_home() abort
  if exists("g:mutagen_vim_home")
    return g:mutagen_vim_home
  endif

  let g:mutagen_vim_home = mutagen#derive_vim_home()
  return g:mutagen_vim_home
endfunction

function! mutagen#load_os_settings() abort
  execute 'source' mutagen#vim_home() . '/os/' . mutagen#os() . '/settings.vim'
  return ''
endfunction

function! mutagen#getcwd() abort
  if mutagen#is_os('darwin') || mutagen#is_os('linux')
    return getcwd()
  endif

  let l:cwd = substitute(getcwd(), '\\', '/', 'g')
  return substitute(l:cwd, '\v^([a-zA-Z]:)', '', '')
endfunction
