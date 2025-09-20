function! ext#ale#handlers#trailing_whitespace#DefineLinter(filetype) abort
    call ale#linter#Define(a:filetype, {
    \   'name': 'trailing_whitespace',
    \   'executable': function(
    \       'ext#ale#handlers#trailing_whitespace#GetExecutable'
    \   ),
    \   'command': function('ext#ale#handlers#trailing_whitespace#GetCommand'),
    \   'callback': 'ext#ale#handlers#trailing_whitespace#Handle',
    \})
endfunction

function! ext#ale#handlers#trailing_whitespace#IsBufferModifiable(buffer) abort
    return getbufvar(a:buffer, '&modifiable')
endfunction

function! ext#ale#handlers#trailing_whitespace#GetExecutable(buffer) abort
    " Used to disable this check if buffer is not modifiable
    if !ext#ale#handlers#trailing_whitespace#IsBufferModifiable(a:buffer)
        return 'echo'
    endif

    return 'rg'
endfunction

function! ext#ale#handlers#trailing_whitespace#GetCommand(buffer) abort
    " Used to disable this check if buffer is not modifiable
    if !ext#ale#handlers#trailing_whitespace#IsBufferModifiable(a:buffer)
        return '%e "{}"'
    endif

    return '%e --json "(\s|\t)+$" %t'
endfunction

function! ext#ale#handlers#trailing_whitespace#Handle(buffer, lines) abort
    let l:output = []

    " Used to disable this check if buffer is not modifiable
    if !ext#ale#handlers#trailing_whitespace#IsBufferModifiable(a:buffer)
        " TODO: make this injectable?
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_trailing_whitespace_statusline',
        \   v:null
        \)
        return l:output
    endif

    for l:line in a:lines
        let l:json = ale#util#FuzzyJSONDecode(l:line, {'type': ''})

        if l:json.type ==# 'match'
            let l:lint_type = 'W'
            let l:lint_text = 'Trailing whitespace'

            call add(l:output, {
            \   'lnum': l:json.data.line_number,
            \   'col': l:json.data.submatches[0].start + 1,
            \   'type': l:lint_type,
            \   'text': l:lint_text,
            \})
        endif
    endfor

    " TODO: make this injectable?
    if empty(l:output)
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_trailing_whitespace_statusline',
        \   v:null
        \)
    else
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_trailing_whitespace_statusline',
        \   '󱁐 ' . len(l:output)
        \)
    endif

    return l:output
endfunction

function! ext#ale#handlers#trailing_whitespace#statusline() abort
    let l:status = b:ale_handlers_trailing_whitespace_statusline

    if l:status is v:null
        return ''
    endif

    return l:status
endfunction
