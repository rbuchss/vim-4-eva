let s:_buffers = getbufinfo({'buflisted':1})

if len(s:_buffers) >= 50
  " Disable running linters when opening too many files to avoid OS maxfiles limit issue
  " Ref: https://github.com/dense-analysis/ale?tab=readme-ov-file#how-can-i-run-linters-only-when-i-save-files
  let g:ale_lint_on_enter = 0
endif

" Disable ALE on terminal buffers (including Claude) to avoid 'Invalid buffer id'
" errors when backgrounding vim with ctrl-z
"
let g:ale_pattern_options = get(g:, 'ale_pattern_options', {})
let g:ale_pattern_options['term://.*'] = {'ale_enabled': 0}

" Disable ALE on claudecode diff buffers to avoid errors from phantom buffers.
" E.g:
"
" stack traceback:
"         [C]: in function 'nvim_create_autocmd'
"         .../neovim/0.11.3/share/nvim/runtime/lua/vim/diagnostic.lua:392: in function '__index'
"         .../neovim/0.11.3/share/nvim/runtime/lua/vim/diagnostic.lua:1169: in function 'set'
"         .../russ/.vim/pack/common/start/ale/lua/ale/diagnostics.lua:85: 
"         in function <.../russ/.vim/pack/common/start/ale/lua/ale/diagnostics.lua:21> function: builtin#18 .../neovim/0.11.3/share/nvim/runtime/lua/vim/
" diagnostic.lua:392: Invalid buffer id: 1049
"
augroup AleClaudeCodeDiffDisable
  autocmd!
  autocmd BufAdd,BufNew * call s:DisableAleForClaudeDiff()
augroup END

function! s:DisableAleForClaudeDiff() abort
  let l:bufname = bufname('%')
  " Check if buffer name contains claudecode diff patterns
  if l:bufname =~# ' (proposed)$' ||
   \ l:bufname =~# ' (NEW FILE - proposed)$' ||
   \ l:bufname =~# ' (New)$' ||
   \ l:bufname =~# ' (NEW FILE)$'
    let b:ale_enabled = 0
  endif
endfunction

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
