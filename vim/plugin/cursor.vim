" autocmd WinLeave * setlocal nocursorline
" autocmd WinEnter * setlocal cursorline
"
" change cursor shape between modes
if mutagen#is_os('windows')
  " " TODO revert cursor on exit
  " "   vintage not supported ...
  " " https://github.com/microsoft/terminal/issues/1604
  " " CSI Ps SP q
  " " Set cursor style (DECSCUSR), VT520.
  " " Ps = 0  -> blinking block.
  " " Ps = 1  -> blinking block (default).
  " " Ps = 2  -> steady block.
  " " Ps = 3  -> blinking underline.
  " " Ps = 4  -> steady underline.
  " " Ps = 5  -> blinking bar (xterm).
  " " Ps = 6  -> steady bar (xterm).
  " NOTE this works but insert <tab> glitches out for some reason ...
  " NOTE this is caused by vim-snipmate/vim-snippets
  let &t_SI .= "\<CSI>5 q"
  let &t_SR .= "\<CSI>4 q"
  let &t_EI .= "\<CSI>0 q"
  " autocmd VimLeave * let &t_me="\<CSI>0 q"
  " NOTE this does not work
  " let &t_SI = "\<Esc>[6 q"
  " let &t_SR = "\<Esc>[4 q"
  " let &t_EI = "\<Esc>[2 q"
elseif mutagen#is_os('darwin') || mutagen#is_os('linux')
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

"-----------------------------------------------------------------------------
" jump to last cursor position when opening a file
" do not do it when writing a commit
"-----------------------------------------------------------------------------
function! SetCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

"-----------------------------------------------------------------------------
" whitespace nuker
"-----------------------------------------------------------------------------
function! Preserve(command)
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

function! StripTrailingWhitespace()
  call Preserve("%s/\\s\\+$//e")
endfunction
