let g:syntastic_stl_format = "[%E{Error: l:%fe #%e}%B{, }%W{Warn: l:%fw #%w}]"

let g:syntastic_error_symbol = '✗'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_warning_symbol = '≈'

let g:syntastic_html_tidy_ignore_errors= [
      \ " proprietary attribute \"ng-",
      \ " proprietary attribute \"on",
      \ ' is not recognized!',
      \ 'discarding unexpected <vango-',
      \ 'discarding unexpected </vango-',
      \ ]
