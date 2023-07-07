" Create syntax groups
execute 'syntax match JournalDone '.g:myjournal_done_pattern
execute 'syntax match JournalMoved '.g:myjournal_moved_pattern
execute 'syntax match JournalNope '.g:myjournal_nope_pattern
execute 'syntax match JournalQuestion '.g:myjournal_question_pattern
execute 'syntax match JournalTodo '.g:myjournal_todo_pattern
execute 'syntax match JournalWip '.g:myjournal_wip_pattern

" Add highlights to each group
highlight default link JournalDone Comment
highlight default link JournalMoved Function
highlight default link JournalNope PreProc
highlight default link JournalQuestion Todo
highlight default link JournalTodo Keyword
highlight default link JournalWip String
