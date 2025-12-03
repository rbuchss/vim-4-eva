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

" Recreate standard NERDCommenter mappings with the c char as a prefix
" Doing this here to allow for customization.
"
call s:CreateMaps('nx', 'Comment',    'Comment', 'cc')
call s:CreateMaps('nx', 'Toggle',     'Toggle', 'c<space>')
call s:CreateMaps('nx', 'Minimal',    'Minimal', 'cm')
call s:CreateMaps('nx', 'Nested',     'Nested', 'cn')
call s:CreateMaps('n',  'ToEOL',      'To EOL', 'c$')
call s:CreateMaps('nx', 'Invert',     'Invert', 'ci')
call s:CreateMaps('nx', 'Sexy',       'Sexy', 'cs')
call s:CreateMaps('nx', 'Yank',       'Yank then comment', 'cy')
call s:CreateMaps('n',  'Append',     'Append', 'cA')
call s:CreateMaps('',   ':',          '-Sep-', '')
call s:CreateMaps('nx', 'AlignLeft',  'Left aligned', 'cl')
call s:CreateMaps('nx', 'AlignBoth',  'Left and right aligned', 'cb')
call s:CreateMaps('',   ':',          '-Sep2-', '')
call s:CreateMaps('nx', 'Uncomment',  'Uncomment', 'cu')
call s:CreateMaps('n',  'AltDelims',  'Switch Delimiters', 'ca')
call s:CreateMaps('i',  'Insert',     'Insert Comment Here', '')
call s:CreateMaps('',   ':',          '-Sep3-', '')
call s:CreateMaps('',   ':help NERDCommenterContents<CR>', 'Help', '')
