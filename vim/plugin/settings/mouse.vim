" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  "set ttymouse=xterm2
endif

if has('mouse_sgr') && !has('nvim')
  set ttymouse=sgr
endif
