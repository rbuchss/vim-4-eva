"-----------------------------------------------------------------------------
" jump to last cursor position when opening a file
" do not do it when writing a commit
"-----------------------------------------------------------------------------
function! vim_4_eva#cursor#SetPosition() abort
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction
