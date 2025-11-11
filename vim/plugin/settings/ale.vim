let s:_buffers = getbufinfo({'buflisted':1})

if len(s:_buffers) >= 50
  " Disable running linters when opening too many files to avoid OS maxfiles limit issue
  " Ref: https://github.com/dense-analysis/ale?tab=readme-ov-file#how-can-i-run-linters-only-when-i-save-files
  let g:ale_lint_on_enter = 0
endif

" Note that if using neovim we use the diagnostic api to set signs
"
" Ref: defaults for diagnostics:
"   DiagnosticError xxx ctermfg=1 guifg=Red
"   DiagnosticWarn xxx ctermfg=3 guifg=Orange
"   DiagnosticInfo xxx ctermfg=4 guifg=LightBlue
" defaults for ale:
"   ALEErrorSign   xxx links to Error
"   ALEWarningSign xxx links to Todo
"   ALEInfoSign    xxx links to ALEWarningSign
"
" Otherwise, we set the ale signs
"
if !has('nvim')
  let g:ale_sign_error = g:vim_4_eva_diagnostic_sign_error
  let g:ale_sign_style_error = g:vim_4_eva_diagnostic_sign_error
  let g:ale_sign_warning = g:vim_4_eva_diagnostic_sign_warning
  let g:ale_sign_style_warning = g:vim_4_eva_diagnostic_sign_warning
  let g:ale_sign_info = g:vim_4_eva_diagnostic_sign_info
endif
