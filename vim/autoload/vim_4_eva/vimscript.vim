"-----------------------------------------------------------------------------
" eval vimscript by begin and end line selection
"-----------------------------------------------------------------------------
function! vim_4_eva#vimscript#Source(begin, end) abort
    let lines = getline(a:begin, a:end)
    for line in lines
        execute line
    endfor
endfunction
