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
      \         'long_line',
      \         'trailing_whitespace',
      \         'linter_checking',
      \         'linter_errors',
      \         'linter_warnings',
      \         'linter_infos',
      \         'linter_ok',
      \         'linter_no_linters',
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
      \     'mode': 'vim_4_eva#statusline#Mode',
      \     'paste': 'vim_4_eva#statusline#Paste',
      \     'gitbranch': 'vim_4_eva#statusline#GitBranch',
      \     'filename': 'vim_4_eva#statusline#Filename',
      \     'modified': 'vim_4_eva#statusline#Modified',
      \
      \     'lineinfo': 'vim_4_eva#statusline#LineInfo',
      \     'percent': 'vim_4_eva#statusline#Percent',
      \     'filetype': 'vim_4_eva#statusline#FileType',
      \     'file_size': 'vim_4_eva#statusline#FileSize',
      \     'ai_status': 'vim_4_eva#statusline#AIStatus',
      \   },
      \   'component_expand': {
      \     'readonly': 'vim_4_eva#statusline#Readonly',
      \     'indentation': 'vim_4_eva#statusline#Indentation',
      \     'long_line': 'vim_4_eva#statusline#LongLine',
      \     'trailing_whitespace': 'vim_4_eva#statusline#TrailingWhitespace',
      \     'linter_checking': 'lightline#ale#checking',
      \     'linter_infos': 'lightline#ale#infos',
      \     'linter_warnings': 'lightline#ale#warnings',
      \     'linter_errors': 'lightline#ale#errors',
      \     'linter_ok': 'lightline#ale#ok',
      \     'linter_no_linters': 'lightline#ale#no_linters',
      \
      \     'fileformat': 'vim_4_eva#statusline#FileFormat',
      \     'fileencoding': 'vim_4_eva#statusline#FileEncoding',
      \   },
      \   'component_type': {
      \     'readonly': 'readonly',
      \     'indentation': 'error',
      \     'long_line': 'warning',
      \     'trailing_whitespace': 'warning',
      \     'linter_checking': 'info',
      \     'linter_infos': 'info',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'info',
      \     'linter_no_linters': 'info',
      \   },
      \ }

set laststatus=2

" Suppressing mode since it will be shown in the statusline
set noshowmode

" Custom theme derived from: autoload/lightline/colorscheme/wombat.vim
" See:
"   https://github.com/itchyny/lightline.vim/blob/master/autoload/lightline/colorscheme/wombat.vim
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

let s:p = {
      \   'normal': {},
      \   'inactive': {},
      \   'insert': {},
      \   'replace': {},
      \   'visual': {},
      \   'tabline': {}
      \ }

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
let g:lightline#ale#indicator_no_linters = get(g:,
      \   'vim_4_eva_sign_no_linters',
      \   '󰢤'
      \ )

" Add right padding to avoid overlapping characters with indicator and numbers.
"
let g:lightline#ale#indicator_right_pad_infos = ' '
let g:lightline#ale#indicator_right_pad_warnings = ' '
let g:lightline#ale#indicator_right_pad_errors = ' '
