let g:myjournal_done_symbol = 'x'
let g:myjournal_moved_symbol = '>'
let g:myjournal_nope_symbol = 'n'
let g:myjournal_question_symbol = '?'
let g:myjournal_todo_symbol = ' '
let g:myjournal_wip_symbol = '-'

let g:myjournal_done_pattern = '/\c- \['.g:myjournal_done_symbol.'\].*/'
let g:myjournal_moved_pattern = '/- \['.g:myjournal_moved_symbol.'\]/'
let g:myjournal_nope_pattern = '/\c- \['.g:myjournal_nope_symbol.'\]/'
let g:myjournal_question_pattern = '/\['.g:myjournal_question_symbol.'\]/'
let g:myjournal_todo_pattern = '/- \['.g:myjournal_todo_symbol.'\]/'
let g:myjournal_wip_pattern = '/- \['.g:myjournal_wip_symbol.'\]/'

function! InsertJournalAbbrev(source, target)
  let line = getline('.')
  if line =~# '^ *'.a:source
    return a:target
  endif
  return a:source
endfunction

" insert fancy signifiers with abbrevs
iabbrev <expr> <buffer> done InsertJournalAbbrev('done', '- ['.g:myjournal_done_symbol.']')
iabbrev <expr> <buffer> moved InsertJournalAbbrev('moved', '- ['.g:myjournal_moved_symbol.']')
iabbrev <expr> <buffer> nope InsertJournalAbbrev('nope', '- ['.g:myjournal_nope_symbol.']')
iabbrev <expr> <buffer> quest InsertJournalAbbrev('quest', '- ['.g:myjournal_question_symbol.']')
iabbrev <expr> <buffer> todo InsertJournalAbbrev('todo', '- ['.g:myjournal_todo_symbol.']')
iabbrev <expr> <buffer> wip InsertJournalAbbrev('wip', '- ['.g:myjournal_wip_symbol.']')
iabbrev <expr> <buffer> ddd strftime('<CR>%Y-%m-%d:<CR>')

setlocal textwidth=0
setlocal wrapmargin=0
