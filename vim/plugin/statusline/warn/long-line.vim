"-----------------------------------------------------------------------------
" long line warning setter
"-----------------------------------------------------------------------------
" Recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning
" return a warning for "long lines" where
" long" is either &textwidth or 80 (if no &textwidth is set)
" return '' if no long lines
" return '[Ł➤x] if long lines are found, were x is the number of long lines
function! StatuslineLongLineWarning()
  if !exists("b:statusline_long_line_warning")
    if !&modifiable
      let b:statusline_long_line_warning = ''
      return b:statusline_long_line_warning
    endif
    let long_lines = s:LongLines()
    if len(long_lines) > 0
      call s:LongLineColorColumn()
      let b:statusline_long_line_warning = "[" .
            \ 'Ł➤' . len(long_lines) . "]"
    else
      let b:statusline_long_line_warning = ""
    endif
  endif
  return b:statusline_long_line_warning
endfunction

" return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
  let threshold = (&tw ? &tw : 80)
  let spaces = repeat(" ", &ts)
  let line_report = map(getline(1,'$'),
        \ "{ 'filename': @%,
        \ 'lnum': v:key+1,
        \ 'col': len(substitute(v:val, '\\t', spaces, 'g')),
        \ 'is_comment': s:IsCommentLine(v:key+1),
        \ 'type': 'W',
        \ 'nr': s:IsCommentLine(v:key+1)+1,
        \ 'text': v:val }")
  return filter(line_report, 'v:val.col > threshold')
endfunction

function s:IsCommentLine(line_num)
  let hg = synIDattr(synID(a:line_num, 1, 0), "name")
  return hg =~? 'comment' ? 1 : 0
endfunction

function s:LongLineColorColumn()
  let threshold = (&tw ? &tw : 80)
  call matchadd('ColorColumn', '\%' . (threshold+1) . 'v.')
endfunction

function s:CodeLongLines()
  let l:report = s:LongLines()
  return filter(l:report, '!v:val.is_comment')
endfunction

function s:CommentLongLines()
  let l:report = s:LongLines()
  return filter(l:report, 'v:val.is_comment')
endfunction

function LongLineReport()
  let l:report = s:LongLines()
  call setqflist(l:report, 'r')
  copen
  let w:quickfix_title = 'LongLineReport'
endfunction

function LongLineCodeReport()
  let l:code_report = s:CodeLongLines()
  call setqflist(l:code_report, 'r')
  copen
  let w:quickfix_title = 'LongLineCodeReport'
endfunction

function LongLineCommentReport()
  let l:comment_report = s:CommentLongLines()
  call setqflist(l:comment_report, 'r')
  copen
  let w:quickfix_title = 'LongLineCommentReport'
endfunction

function s:IsLongLineReportOpen()
  let l:result = filter(getwininfo(),
        \ 'v:val.quickfix && !v:val.loclist && v:val.variables.quickfix_title =~ "LongLine.*Report"')
  return len(l:result)
endfunction

function ToggleLongLineReport()
  if s:IsLongLineReportOpen()
    cclose
  else
    call LongLineReport()
  endif
endfunction

nmap <leader>ll :call ToggleLongLineReport()<CR>
