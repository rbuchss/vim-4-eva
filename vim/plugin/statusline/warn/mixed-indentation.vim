" TODO: convert this into an ale linter
"-----------------------------------------------------------------------------
" mixed indentation warning setter
"-----------------------------------------------------------------------------
" Recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning
" return if &expandtab is set wrong
" return if spaces and tabs are used to indent
" return an empty string if everything is fine
function! StatuslineTabWarning()
  if !exists("b:statusline_tab_warning")
    let b:statusline_tab_warning = ''
    if !&modifiable
      return b:statusline_tab_warning
    endif
    let tabs = search('^\t', 'nw') != 0
    "find spaces that arent used as alignment in the first indent column
    let spaces = search('^ \{' . &tabstop . ',}[^\t]', 'nw') != 0
    if tabs && spaces
      " Warning for mixed-indenting.
      " If spaces and tabs are used to indent
      let b:statusline_tab_warning = ''
    elseif (spaces && !&expandtab) || (tabs && &expandtab)
      " Warning for invalid indentation relative to &expandtab setting.
      " If &expandtab is set wrong.
      let b:statusline_tab_warning = ''
    endif
  endif
  return b:statusline_tab_warning
endfunction
