function! ext#ale#SetBufferVar(buffer, variable_name, default) abort
    let l:full_name = 'ale_' . a:variable_name
    call setbufvar(str2nr(a:buffer), l:full_name, a:default)
endfunction
