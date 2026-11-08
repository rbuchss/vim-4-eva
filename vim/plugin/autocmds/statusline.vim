" Refresh the statusline after writes. ALE refreshes it through
" lightline-ale after each lint pass, but files with no linters would
" otherwise stay stale until the next buffer or window switch. Debounced
" with a timer so bursts of writes (:wa, autosave) coalesce into a single
" refresh.
"
let s:refresh_timer = -1

function! s:ScheduleRefresh() abort
  call timer_stop(s:refresh_timer)
  let s:refresh_timer = timer_start(100, {-> lightline#update()})
endfunction

augroup vim_4_eva#plugin#statusline
  autocmd!
  autocmd BufWritePost * call s:ScheduleRefresh()
augroup END
