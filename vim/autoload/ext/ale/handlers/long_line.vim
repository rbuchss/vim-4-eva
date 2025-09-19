call ale#Set('max_line_length', v:null)

function! ext#ale#handlers#long_line#DefineLinter(filetype) abort
    call ale#linter#Define(a:filetype, {
    \   'name': 'long_line',
    \   'executable': function('ext#ale#handlers#long_line#GetExecutable'),
    \   'command': function('ext#ale#handlers#long_line#GetCommand'),
    \   'callback': 'ext#ale#handlers#long_line#Handle',
    \})
endfunction

function! ext#ale#handlers#long_line#GetMaxLineLength(buffer) abort
    let l:max_length = ale#Var(a:buffer, 'max_line_length')

    if l:max_length is v:null
        let l:max_length = getbufvar(a:buffer, '&textwidth')
    endif

    return l:max_length
endfunction

function! ext#ale#handlers#long_line#GetExecutable(buffer) abort
    let l:max_length = ext#ale#handlers#long_line#GetMaxLineLength(a:buffer)

    " Used to disable this check if setting is unlimited <= 0
    if l:max_length <= 0
        return 'echo'
    endif

    return 'rg'
endfunction

function! ext#ale#handlers#long_line#GetCommand(buffer) abort
    let l:max_length = ext#ale#handlers#long_line#GetMaxLineLength(a:buffer)
    "
    " Used to disable this check if setting is unlimited <= 0
    if l:max_length <= 0
        return '%e "{}"'
    endif

    return '%e --json ".{' . l:max_length . '}.+" %t'
endfunction

function! ext#ale#handlers#long_line#Handle(buffer, lines) abort
    let l:output = []
    let l:max_length = ext#ale#handlers#long_line#GetMaxLineLength(a:buffer)

    " Used to disable this check if setting is unlimited <= 0
    if l:max_length <= 0
        " TODO: make this injectable?
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_long_line_statusline',
        \   v:null
        \)
        return l:output
    endif

    for l:line in a:lines
        let l:json = ale#util#FuzzyJSONDecode(l:line, {'type': ''})

        if l:json.type ==# 'match'
            let l:lint_type = 'W'
            let l:lint_text = 'Line too long (line length: '
                  \   . l:json.data.submatches[0].end
                  \   . ' > max length: ' . l:max_length . ')'

            call add(l:output, {
            \   'lnum': l:json.data.line_number,
            \   'col': l:max_length + 1,
            \   'type': l:lint_type,
            \   'text': l:lint_text,
            \})
        endif
    endfor

    " TODO: make this injectable?
    if empty(l:output)
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_long_line_statusline',
        \   v:null
        \)
    else
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_long_line_statusline',
        \   '󰌑 ' . len(l:output)
        \)
    endif

    return l:output
endfunction

function! ext#ale#handlers#long_line#statusline() abort
    let l:long_line_statusline = b:ale_handlers_long_line_statusline

    if l:long_line_statusline is v:null
        return ''
    endif

    return l:long_line_statusline
endfunction
