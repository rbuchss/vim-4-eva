"-----------------------------------------------------------------------------
" return the syntax highlight group under the cursor ''
"-----------------------------------------------------------------------------
" Returns syntax highlighting group the current "thing" under the cursor
nmap <silent> ,qq :echo 'stack' . StatuslineCurrentSynStack() .
      \ ' hi' . StatuslineCurrentHighlight() .
      \ ' trans' . StatuslineCurrentTrans() .
      \ ' lo' . StatuslineCurrentLo() <CR>

function! StatuslineCurrentHighlight()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentTrans()
  let name = synIDattr(synID(line('.'),col('.'),0),"name")
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentLo()
  let name = synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentSynStack()
  if !exists("*synstack")
    return
  endif
  let stack = map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  return '[' . join(stack, ', ') . ']'
endfunc

function! LinterStatus() abort
    let l:_buffer = bufnr('')
    let l:counts = ale#statusline#Count(l:_buffer)

    if l:counts.total == 0
      return ''
    endif

    " " We can add the first line here as well with this logic
    " " Ref: https://github.com/dense-analysis/ale/blob/6fd9f3c54f80cec8be364594246daf9ac41cbe3e/doc/ale.txt#L4680
    " let l:first_error = ale#statusline#FirstProblem(l:_buffer, 'error')
    " let l:first_style_error = ale#statusline#FirstProblem(l:_buffer, 'style_error')
    " let l:first_warning = ale#statusline#FirstProblem(l:_buffer, 'warning')
    " let l:first_style_warning = ale#statusline#FirstProblem(l:_buffer, 'style_warning')

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_warnings = l:counts.warning + l:counts.style_warning
    let l:all_others = l:counts.total - l:all_errors - l:all_warnings

    let l:output = []

    if l:all_errors > 0
      call add(l:output, printf('Error: #%d', l:all_errors))
    endif

    if l:all_warnings > 0
      call add(l:output, printf('Warn: #%d', l:all_warnings))
    endif

    if l:all_others > 0
      call add(l:output, printf('Other: #%d', l:all_others))
    endif

    return '[' . join(l:output, ', ') . ']'
endfunction
