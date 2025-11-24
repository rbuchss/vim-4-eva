" Custom functions for lightline component_function and component_expand
"
let s:filetypes_with_no_lightline = '\v(nerdtree|netrw|dapui_|dap-repl)'

function! vim_4_eva#statusline#Mode()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if &readonly && &filetype ==# 'help'
    return ''
  endif

  return lightline#mode()
endfunction

function! vim_4_eva#statusline#Paste()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return &paste ? 'PASTE' : ''
endfunction

function! vim_4_eva#statusline#Readonly()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return &filetype !~? 'vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! vim_4_eva#statusline#GitBranch(len = 7)
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if &readonly && &filetype ==# 'help'
    return ''
  endif

  " Get either branch name or commit id with full 40 bytes
  let head = fugitive#head(-1)

  if empty(head)
    return ''
  elseif head =~# '^\x\{40,\}$'
    let content = a:len < 0 ? head : strpart(head, 0, a:len).'...'
    return '  ('.content.')'
  else
    return ' '.head
  endif
endfunction

function! vim_4_eva#statusline#Filename()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  let pre = ''
  let pat = '://'
  let name = expand('%:~:.')

  if name =~# pat
    let pre = name[:stridx(name, pat) + len(pat)-1] . '...'
    let name = name[stridx(name, pat) + len(pat):]
  endif

  let name = simplify(name)
  let ratio = (1.0 * winwidth(0)) / len(name)

  if ratio <= 2 && ratio > 1.5
    let name = pathshorten(name)
  elseif ratio <= 1.5
    let name = fnamemodify(name, ':t')
  endif

  return pre . name
endfunction

function! vim_4_eva#statusline#Modified()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if &modified
    return '+'
  endif

  if !&modifiable
    return '-'
  endif

  return ''
endfunction

function! vim_4_eva#statusline#Indentation()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return StatuslineTabWarning()
endfunction

" NOTE: This gets updated async with ale
function! vim_4_eva#statusline#LongLine()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return ext#ale#handlers#long_line#statusline()
endfunction

function! vim_4_eva#statusline#TrailingWhitespace()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return ext#ale#handlers#trailing_whitespace#statusline()
endfunction

function! vim_4_eva#statusline#LinterStatus()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

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

" Useful for debugging syntax highlighting.
function! vim_4_eva#statusline#CurrentHighlight()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return vim_4_eva#syntax#CurrentHighlight()
endfunction

function! vim_4_eva#statusline#LineInfo()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " statusline equivalent of '%3l:%-2c'
  return printf('%3d:%-2d', line('.'), col('.'))
endfunction

function! vim_4_eva#statusline#Percent()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " statusline equivalent of '%3p%%'
  return printf('%3d%%', 100 * line('.') / line('$'))
endfunction

function! vim_4_eva#statusline#FileFormat()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " display a warning if fileformat is not unix
  return &ff !=# 'unix' ? &ff : ''
endfunction

function! vim_4_eva#statusline#FileEncoding()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " display a warning if file encoding is not utf-8
  return &fenc !=# 'utf-8' && &fenc !=# '' ? &fenc : ''
endfunction

function! vim_4_eva#statusline#AIStatus()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if !has('nvim')
    return ''
  endif

  return v:lua.require('vim_4_eva.plugin.settings.statusline').ai_status()
endfunction

function! vim_4_eva#statusline#FileType()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if winwidth(0) < 80
    return ''
  endif

  return &filetype !=# '' ? &filetype : 'no ft'
endfunction

function! vim_4_eva#statusline#FileSize()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if winwidth(0) < 120
    return ''
  endif

  return vim_4_eva#file#Size()
endfunction
