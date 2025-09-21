function! ext#ale#syntax#IsLineCommented(
\   buffer,
\   language,
\   line
\) abort
    " If we are using neovim use the treesitter as it should be the most
    " inaccurate and have the best performance.
    if has('nvim')
        return v:lua.require('vim_4_eva.syntax').is_line_commented(
        \   a:buffer,
        \   a:language,
        \   a:line
        \)
    endif

    " Otherwise, fallback to commenter library.
    "
    " TODO: make this work with a buffer specified?
    " Currently this assumes the current buffer which can lead to inaccurate
    " results. However, nerdcommenter does not currently support this.
    "
    " TODO: allow for this to be injectable?
    "
    return NERDCommentIsLineCommented(a:line)
endfunction

function! ext#ale#syntax#IsPositionCommented(
\   buffer,
\   language,
\   line,
\   column
\) abort
    " If we are using neovim use the treesitter as it should be the most
    " inaccurate and have the best performance.
    if has('nvim')
        return v:lua.require('vim_4_eva.syntax').is_position_commented(
        \   a:buffer,
        \   a:language,
        \   a:line,
        \   a:column
        \)
    endif

    " Otherwise, fallback to commenter library.
    "
    " TODO: make this work with a buffer specified?
    " Currently this assumes the current buffer which can lead to inaccurate
    " results. However, nerdcommenter does not currently support this.
    "
    " TODO: allow for this to be injectable?
    "
    return NERDCommentIsLineCommented(a:line)
endfunction
