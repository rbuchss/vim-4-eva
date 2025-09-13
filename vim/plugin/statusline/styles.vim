" Using lightline.vim for the statusline config here.
" See: https://github.com/itchyny/lightline.vim
"
let g:lightline = {
      \   'colorscheme': 'zombat',
      \   'active': {
      \     'left': [
      \       [
      \         'mode',
      \         'paste',
      \       ],
      \       [
      \         'readonly',
      \         'gitbranch',
      \         'filename',
      \         'modified',
      \       ],
      \       [
      \         'indentation',
      \         'trailing_whitespace',
      \         'linter_status',
      \       ],
      \     ],
      \     'right': [
      \       [
      \         'lineinfo',
      \       ],
      \       [
      \         'percent',
      \       ],
      \       [
      \         'ai_status',
      \         'fileformat',
      \         'fileencoding',
      \         'filetype',
      \         'file_size',
      \       ],
      \     ],
      \   },
      \   'inactive': {
      \     'left': [
      \       [
      \         'filename',
      \         'modified',
      \       ],
      \     ],
      \     'right': [
      \       [
      \         'lineinfo',
      \       ],
      \       [
      \         'percent',
      \       ],
      \       [
      \         'filetype',
      \         'file_size',
      \       ],
      \     ],
      \   },
      \   'component_function': {
      \     'mode': 'statusline#styles#mode',
      \     'paste': 'statusline#styles#paste',
      \     'gitbranch': 'statusline#styles#git_branch',
      \     'filename': 'statusline#styles#filename',
      \     'modified': 'statusline#styles#modified',
      \
      \     'lineinfo': 'statusline#styles#line_info',
      \     'percent': 'statusline#styles#percent',
      \     'filetype': 'statusline#styles#file_type',
      \     'file_size': 'statusline#styles#file_size',
      \     'ai_status': 'statusline#styles#ai_status',
      \   },
      \   'component_expand': {
      \     'readonly': 'statusline#styles#readonly',
      \     'indentation': 'statusline#styles#indentation',
      \     'trailing_whitespace': 'statusline#styles#trailing_whitespace',
      \     'linter_status': 'statusline#styles#linter_status',
      \
      \     'fileformat': 'statusline#styles#file_format',
      \     'fileencoding': 'statusline#styles#file_encoding',
      \   },
      \   'component_type': {
      \     'readonly': 'readonly',
      \     'indentation': 'error',
      \     'trailing_whitespace': 'warning',
      \     'linter_status': 'error',
      \   },
      \ }

set laststatus=2

" Suppressing mode since it will be shown in the statusline
set noshowmode

" Custom theme derived from: autoload/lightline/colorscheme/wombat.vim
" See: https://github.com/itchyny/lightline.vim/blob/master/autoload/lightline/colorscheme/wombat.vim
"
let s:base03 = [ '#242424', 235 ]
let s:base023 = [ '#353535', 236 ]
let s:base02 = [ '#444444', 238 ]
let s:base01 = [ '#585858', 240 ]
let s:base00 = [ '#666666', 242  ]
let s:base0 = [ '#808080', 244 ]
let s:base1 = [ '#969696', 247 ]
let s:base2 = [ '#a8a8a8', 248 ]
let s:base3 = [ '#d0d0d0', 252 ]
let s:yellow = [ '#cae682', 180 ]
let s:orange = [ '#e5786d', 173 ]
let s:red = [ '#e5786d', 203 ]
let s:magenta = [ '#f2c68a', 216 ]
let s:blue = [ '#8ac6f2', 117 ]
let s:cyan = s:blue
let s:green = [ '#95e454', 119 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left     = [ [ s:base02, s:blue ], [ s:base3, s:base01 ] ]
let s:p.normal.middle   = [ [ s:base2, s:base02 ] ]
let s:p.normal.right    = [ [ s:base02, s:base0 ], [ s:base1, s:base01 ] ]
let s:p.normal.error    = [ [ s:red, s:base02 ] ]
let s:p.normal.warning  = [ [ s:yellow, s:base02 ] ]
let s:p.normal.info     = [ [ s:blue, s:base02 ] ]
let s:p.normal.readonly = [ [ s:yellow, s:base01 ] ]
let s:p.insert.left     = [ [ s:base02, s:green ], [ s:base3, s:base01 ] ]
let s:p.insert.right    = [ [ s:base02, s:green ], [ s:base3, s:base01 ] ]
let s:p.replace.left    = [ [ s:base023, s:red ], [ s:base3, s:base01 ] ]
let s:p.replace.right   = [ [ s:base023, s:red ], [ s:base3, s:base01 ] ]
let s:p.visual.left     = [ [ s:base02, s:magenta ], [ s:base3, s:base01 ] ]
let s:p.visual.right    = [ [ s:base02, s:magenta ], [ s:base3, s:base01 ] ]
let s:p.tabline.left    = [ [ s:base3, s:base00 ] ]
let s:p.tabline.tabsel  = [ [ s:base3, s:base03, 'bold' ] ]
let s:p.tabline.middle  = [ [ s:base2, s:base02 ] ]
let s:p.tabline.right   = [ [ s:base2, s:base00 ] ]
let s:p.inactive.left   = [ [ s:base1, s:base02 ], [ s:base00, s:base023 ] ]
let s:p.inactive.middle = [ [ s:base1, s:base023 ] ]
let s:p.inactive.right  = [ [ s:base023, s:base01 ], [ s:base00, s:base02 ] ]

let g:lightline#colorscheme#zombat#palette = lightline#colorscheme#flatten(s:p)

" Custom icons for lightline-ale
"
let g:lightline#ale#indicator_infos = get(g:, 'vim_4_eva_sign_info', '')
let g:lightline#ale#indicator_warnings = get(g:, 'vim_4_eva_sign_warning', '')
let g:lightline#ale#indicator_errors = get(g:, 'vim_4_eva_sign_error', '')
let g:lightline#ale#indicator_ok = get(g:, 'vim_4_eva_sign_ok', '')
let g:lightline#ale#indicator_checking = get(g:, 'vim_4_eva_sign_checking', '')

" Custom functions for lightline component_function and component_expand
"
let s:filetypes_with_no_lightline = '\v(nerdtree|netrw)'

function! statusline#styles#mode()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if &readonly && &filetype ==# 'help'
    return ''
  endif

  return lightline#mode()
endfunction

function! statusline#styles#paste()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return &paste ? 'PASTE' : ''
endfunction

function! statusline#styles#readonly()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return ReadOnlyFlag()
endfunction

function! statusline#styles#git_branch()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if &readonly && &filetype ==# 'help'
    return ''
  endif

  return GitStatusline()
endfunction

function! statusline#styles#filename()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return StatusLineFileName()
endfunction

function! statusline#styles#modified()
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

function! statusline#styles#indentation()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return StatuslineTabWarning()
endfunction

" NOTE: The current StatuslineLongLineWarning implementation is very slow
" so disabling for now in the statusline.
function! statusline#styles#long_line()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return StatuslineLongLineWarning()
endfunction

function! statusline#styles#trailing_whitespace()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return StatuslineTrailingSpaceWarning()
endfunction

function! statusline#styles#linter_status()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return LinterStatus()
endfunction

" Useful for debugging syntax highlighting.
function! statusline#styles#current_highlight()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  return StatuslineCurrentHighlight()
endfunction

function! statusline#styles#line_info()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " statusline equivalent of '%3l:%-2c'
  return printf('%3d:%-2d', line('.'), col('.'))
endfunction

function! statusline#styles#percent()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " statusline equivalent of '%3p%%'
  return printf('%3d%%', 100 * line('.') / line('$'))
endfunction

function! statusline#styles#file_format()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " display a warning if fileformat is not unix
  return &ff !=# 'unix' ? &ff : ''
endfunction

function! statusline#styles#file_encoding()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  " display a warning if file encoding is not utf-8
  return &fenc !=# 'utf-8' && &fenc !=# '' ? &fenc : ''
endfunction

function! statusline#styles#ai_status()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if !has('nvim')
    return ''
  endif

  return v:lua.CustomStatus.ai_status()
endfunction

function! statusline#styles#file_type()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if winwidth(0) < 80
    return ''
  endif

  return &filetype !=# '' ? &filetype : 'no ft'
endfunction

function! statusline#styles#file_size()
  if &filetype =~# s:filetypes_with_no_lightline
    return ''
  endif

  if winwidth(0) < 120
    return ''
  endif

  return FileSize()
endfunction

" Note with component_expand we need these autocmds to
" run to refesh the stattusline state. Otherwise, the
" components will become stale.
"
augroup statusline#styles
  autocmd!
  autocmd User ALEJobStarted call lightline#update()
  autocmd User ALELintPost call lightline#update()
  autocmd User ALEFixPost call lightline#update()
augroup END
