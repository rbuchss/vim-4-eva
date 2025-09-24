" autocmd WinLeave * setlocal nocursorline
" autocmd WinEnter * setlocal cursorline

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost * call vim_4_eva#cursor#SetPosition()
