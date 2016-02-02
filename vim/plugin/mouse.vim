" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  "set ttymouse=xterm2
endif

"-----------------------------------------------------------------------------
" mouse mode toggle
"-----------------------------------------------------------------------------
fun! s:ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
        set number
        echo "Mouse is for Vim (" . &mouse . ")"
    else
        let s:old_mouse = &mouse
        let &mouse=""
        set nonumber
        echo "Mouse is for terminal"
    endif
endfunction

noremap <leader>mt :call <SID>ToggleMouse()<CR>
inoremap <leader>mt <Esc>:call <SID>ToggleMouse()<CR>a
