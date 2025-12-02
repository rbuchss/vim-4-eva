" This must exist for the following function to work.
" This uses the default from NERDCommenter which would normally
" define this, however that is sourced after hence why it exists
" here.
"
let g:NERDMenuMode = 3

" Lifted from NERDCommenter to allow for remapping comment mappings
"
function! s:CreateMaps(modes, target, desc, combo)
    " Build up a map command like
    " 'noremap <silent> <plug>NERDCommenterComment :call NERDComment("n", "Comment")'
    let plug = '<plug>NERDCommenter' . a:target
    let plug_start = 'noremap <silent> ' . plug . ' :call NERDComment("'
    let plug_end = '", "' . a:target . '")<cr>'
    " Build up a menu command like
    " 'menu <silent> comment.Comment<Tab>\\cc <plug>NERDCommenterComment'
    let menuRoot = get(['', 'comment', '&comment', '&Plugin.&comment'],
                \ g:NERDMenuMode, '')
    let menu_command = 'menu <silent> ' . menuRoot . '.' . escape(a:desc, ' ')
    if strlen(a:combo)
        let leader = exists('g:mapleader') ? g:mapleader : '\'
        let menu_command .= '<Tab>' . escape(leader, '\') . a:combo
    endif
    let menu_command .= ' ' . (strlen(a:combo) ? plug : a:target)
    " Execute the commands built above for each requested mode.
    for mode in (a:modes ==# '') ? [''] : split(a:modes, '\zs')
        if strlen(a:combo)
            execute mode . plug_start . mode . plug_end
            if !hasmapto(plug, mode)
                execute mode . 'map <leader>' . a:combo . ' ' . plug
            endif
        endif
        " Check if the user wants the menu to be displayed.
        if g:NERDMenuMode !=# 0
            execute mode . menu_command
        endif
    endfor
endfunction

" Recreate standard NERDCommenter mappings except with the / char as a prefix
"
call s:CreateMaps('nx', 'Comment',    'Comment', '/c')
call s:CreateMaps('nx', 'Toggle',     'Toggle', '/<space>')
call s:CreateMaps('nx', 'Minimal',    'Minimal', '/m')
call s:CreateMaps('nx', 'Nested',     'Nested', '/n')
call s:CreateMaps('n',  'ToEOL',      'To EOL', '/$')
call s:CreateMaps('nx', 'Invert',     'Invert', '/i')
call s:CreateMaps('nx', 'Sexy',       'Sexy', '/s')
call s:CreateMaps('nx', 'Yank',       'Yank then comment', '/y')
call s:CreateMaps('n',  'Append',     'Append', '/A')
call s:CreateMaps('',   ':',          '-Sep-', '')
call s:CreateMaps('nx', 'AlignLeft',  'Left aligned', '/l')
call s:CreateMaps('nx', 'AlignBoth',  'Left and right aligned', '/b')
call s:CreateMaps('',   ':',          '-Sep2-', '')
call s:CreateMaps('nx', 'Uncomment',  'Uncomment', '/u')
call s:CreateMaps('n',  'AltDelims',  'Switch Delimiters', '/a')
call s:CreateMaps('i',  'Insert',     'Insert Comment Here', '')
call s:CreateMaps('',   ':',          '-Sep3-', '')
call s:CreateMaps('',   ':help NERDCommenterContents<CR>', 'Help', '')
