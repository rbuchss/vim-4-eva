function! ext#ale#handlers#mixed_indentation#DefineLinter(filetype) abort
    call ale#linter#Define(a:filetype, {
    \   'name': 'mixed_indentation',
    \   'executable': function(
    \       'ext#ale#handlers#mixed_indentation#GetExecutable'
    \   ),
    \   'command': function('ext#ale#handlers#mixed_indentation#GetCommand'),
    \   'callback': 'ext#ale#handlers#mixed_indentation#Handle',
    \})
endfunction

function! ext#ale#handlers#mixed_indentation#IsBufferModifiable(buffer) abort
    return getbufvar(a:buffer, '&modifiable')
endfunction

function! ext#ale#handlers#mixed_indentation#GetExecutable(buffer) abort
    " Used to disable this check if buffer is not modifiable
    if !ext#ale#handlers#mixed_indentation#IsBufferModifiable(a:buffer)
        return 'echo'
    endif

    return 'rg'
endfunction

function! ext#ale#handlers#mixed_indentation#GetCommand(buffer) abort
    " Used to disable this check if buffer is not modifiable
    if !ext#ale#handlers#mixed_indentation#IsBufferModifiable(a:buffer)
        return '%e "{}"'
    endif

    " Match lines indented with a tab or with at least a 'tabstop' wide
    " block of spaces, the same indentation the old statusline warning
    " flagged.
    let l:tabstop = getbufvar(a:buffer, '&tabstop')

    return '%e --json ''^\t|^ {' . l:tabstop . ',}[^\t]'' %t'
endfunction

function! ext#ale#handlers#mixed_indentation#Handle(buffer, lines) abort
    let l:output = []

    " Used to disable this check if buffer is not modifiable
    if !ext#ale#handlers#mixed_indentation#IsBufferModifiable(a:buffer)
        " TODO: make this injectable?
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_mixed_indentation_statusline',
        \   v:null
        \)
        return l:output
    endif

    let l:tab_lnums = []
    let l:space_lnums = []

    for l:line in a:lines
        let l:json = ale#util#FuzzyJSONDecode(l:line, {'type': ''})

        if l:json.type ==# 'match'
            if l:json.data.submatches[0].match.text[0] ==# "\t"
                call add(l:tab_lnums, l:json.data.line_number)
            else
                call add(l:space_lnums, l:json.data.line_number)
            endif
        endif
    endfor

    let l:statusline_warning = v:null
    let l:lnums = []
    let l:text = ''

    if !empty(l:tab_lnums) && !empty(l:space_lnums)
        " Warning for mixed-indenting.
        " If spaces and tabs are used to indent, flag the lines of the less
        " used style since those are the ones to convert. Ties go to the
        " style that disagrees with 'expandtab'.
        let l:statusline_warning = ''
        let l:spaces_minority = len(l:space_lnums) < len(l:tab_lnums)
              \ || (len(l:space_lnums) == len(l:tab_lnums)
              \     && !getbufvar(a:buffer, '&expandtab'))

        if l:spaces_minority
            let l:lnums = l:space_lnums
            let l:text = 'Mixed indentation (spaces)'
        else
            let l:lnums = l:tab_lnums
            let l:text = 'Mixed indentation (tabs)'
        endif
    elseif !empty(l:tab_lnums) && getbufvar(a:buffer, '&expandtab')
        " Warning for invalid indentation relative to &expandtab setting.
        " If &expandtab is set wrong.
        let l:statusline_warning = ''
        let l:lnums = l:tab_lnums
        let l:text = "Tab indentation with 'expandtab' set"
    elseif !empty(l:space_lnums) && !getbufvar(a:buffer, '&expandtab')
        " Warning for invalid indentation relative to &expandtab setting.
        " If &expandtab is set wrong.
        let l:statusline_warning = ''
        let l:lnums = l:space_lnums
        let l:text = "Space indentation with 'noexpandtab' set"
    endif

    for l:lnum in l:lnums
        call add(l:output, {
        \   'lnum': l:lnum,
        \   'col': 1,
        \   'type': 'W',
        \   'text': l:text,
        \})
    endfor

    " TODO: make this injectable?
    if empty(l:output)
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_mixed_indentation_statusline',
        \   v:null
        \)
    else
        call ext#ale#SetBufferVar(
        \   a:buffer,
        \   'handlers_mixed_indentation_statusline',
        \   l:statusline_warning . ' ' . len(l:output)
        \)
    endif

    return l:output
endfunction

function! ext#ale#handlers#mixed_indentation#statusline() abort
    let l:status = get(b:, 'ale_handlers_mixed_indentation_statusline', v:null)

    if l:status is v:null
        return ''
    endif

    return l:status
endfunction
