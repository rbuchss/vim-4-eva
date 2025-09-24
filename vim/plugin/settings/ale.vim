let s:_buffers = getbufinfo({'buflisted':1})

if len(s:_buffers) >= 100
  " Disable running linters when opening too many files to avoid OS maxfiles limit issue
  " Ref: https://github.com/dense-analysis/ale?tab=readme-ov-file#how-can-i-run-linters-only-when-i-save-files
  let g:ale_lint_on_enter = 0
endif

let g:vim_4_eva_sign_error = '✗'
let g:vim_4_eva_sign_warning = ''
let g:vim_4_eva_sign_info = ''

if !has('nvim')
  let g:ale_sign_error = g:vim_4_eva_sign_error
  let g:ale_sign_style_error = g:vim_4_eva_sign_error
  let g:ale_sign_warning = g:vim_4_eva_sign_warning
  let g:ale_sign_style_warning = g:vim_4_eva_sign_warning
  let g:ale_sign_info = g:vim_4_eva_sign_info
else
  " Using neovim diagnostic api to set signs
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
lua << EOF
  local signs = {
    Error = { icon = vim.g.vim_4_eva_sign_error, texthl = 'Error' },
    Warn = { icon = vim.g.vim_4_eva_sign_warning, texthl = 'Todo' },
    Info = { icon = vim.g.vim_4_eva_sign_info, texthl = 'Todo' },
  }

  for type, data in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = data['icon'], texthl = data['texthl'], numhl = hl })
  end
EOF
endif
