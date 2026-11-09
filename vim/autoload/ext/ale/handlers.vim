" Shared statusline plumbing for the linter handlers under
" ext/ale/handlers/. Each handler injects its name plus the statusline text
" to display for it; v:null clears the statusline.
function! ext#ale#handlers#SetStatusline(buffer, handler, status) abort
    call ext#ale#SetBufferVar(
    \   a:buffer,
    \   'handlers_' . a:handler . '_statusline',
    \   a:status
    \)
endfunction

function! ext#ale#handlers#GetStatusline(handler) abort
    let l:status = get(
    \   b:,
    \   'ale_handlers_' . a:handler . '_statusline',
    \   v:null
    \)

    if l:status is v:null
        return ''
    endif

    return l:status
endfunction
