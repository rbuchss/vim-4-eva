" Injectable comment detector, set via SetCommentDetector. Called with the
" same arguments as the built-in lookups: buffer, language, zero-indexed
" line, and a zero-indexed column or v:null when the whole line is asked
" about. v:null resets to the built-in lookups.
let s:comment_detector = v:null

function! ext#ale#syntax#SetCommentDetector(detector) abort
    let s:comment_detector = a:detector
endfunction

function! s:IsCommented(buffer, language, line, column) abort
    if s:comment_detector isnot# v:null
        return call(s:comment_detector, [a:buffer, a:language, a:line, a:column])
    endif

    " If we are using neovim use the treesitter as it should be the most
    " inaccurate and have the best performance.
    if has('nvim')
        if a:column is v:null
            return v:lua.require('vim_4_eva.syntax').is_line_commented(
            \   a:buffer,
            \   a:language,
            \   a:line
            \)
        endif

        return v:lua.require('vim_4_eva.syntax').is_position_commented(
        \   a:buffer,
        \   a:language,
        \   a:line,
        \   a:column
        \)
    endif

    " Otherwise, fallback to commenter library. It only knows the current
    " buffer, whole lines, and 1-based line numbers; for other buffers stay
    " conservative and report the line as not commented.
    if str2nr(a:buffer) != bufnr('')
        return 0
    endif

    return nerdcommenter#IsLineCommented(a:line + 1)
endfunction

function! ext#ale#syntax#IsLineCommented(
\   buffer,
\   language,
\   line
\) abort
    return s:IsCommented(a:buffer, a:language, a:line, v:null)
endfunction

function! ext#ale#syntax#IsPositionCommented(
\   buffer,
\   language,
\   line,
\   column
\) abort
    return s:IsCommented(a:buffer, a:language, a:line, a:column)
endfunction
