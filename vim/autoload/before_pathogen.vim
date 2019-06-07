if exists("g:loaded_before_pathogen") || &cp
  finish
endif
let g:loaded_before_pathogen = 1

function! before_pathogen#infect(...) abort " {{{1
  call before_pathogen#set_disabled()
  return ''
endfunction " }}}1

function! before_pathogen#set_disabled(...) abort " {{{1
  " https://stackoverflow.com/questions/4261785/temporarily-disable-some-plugins-using-pathogen-in-vim
  " https://stackoverflow.com/questions/48933/how-do-i-list-loaded-plugins-in-vim
  let g:pathogen_disabled = []
  let s:disabled_file = expand("~/.vim/pathogen.disabled")

  if filereadable(s:disabled_file)
    let s:lines = readfile(s:disabled_file)

    for s:line in s:lines
      if isdirectory(expand('~/.vim/bundle/').s:line)
        call add(g:pathogen_disabled, s:line)
      endif
    endfor

  endif
  return ''
endfunction " }}}1
