"-----------------------------------------------------------------------------
" mouse mode toggle
"-----------------------------------------------------------------------------
function! vim_4_eva#mouse#ToggleMode() abort
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
