" statusline setup
set statusline=%#identifier#
set statusline+=%h

" read only flag
set statusline+=%#warningmsg#
set statusline+=%{ReadOnlyFlag()}
set statusline+=%*

set statusline+=%#identifier#
set statusline+=[
set statusline+=%{GitStatusline()}
set statusline+=%{StatusLineFileName()}
set statusline+=]
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

" TODO is this what is slow???
" NOTE this def causes a slow down with the IsCommentLine function ...
" see:

" FUNCTION  <SNR>43_IsCommentLine()
    " Defined: ~/.homesick/repos/vim-4-eva/vim/plugin/statusline/warn/long-line.vim:43
" Called 6642 times
" Total time:   0.512275
 " Self time:   0.512275

" count  total (s)   self (s)
 " 6642              0.478979   let hg = synIDattr(synID(a:line_num, 1, 0), "name")
 " 6642              0.028917   return hg =~? 'comment' ? 1 : 0

" FUNCTION  <SNR>43_LongLines()
    " Defined: ~/.homesick/repos/vim-4-eva/vim/plugin/statusline/warn/long-line.vim:29
" Called 9 times
" Total time:   0.602360
 " Self time:   0.090085

" count  total (s)   self (s)
    " 9              0.000043   let threshold = (&tw ? &tw : 80)
    " 9              0.000036   let spaces = repeat(" ", &ts)
    " 9   0.596721   0.084446   let line_report = map(getline(1,'$'), "{ 'filename': @%, 'lnum': v:key+1, 'col': len(substitute(v:val, '\\t', spaces, 'g')), 'is_comment': s:IsCommentLine(v:key+1), 'type': 'W', 'nr': s:IsCommentLine(v:key+1)+1, 'text': v:val }")
    " 9              0.005539   return filter(line_report, 'v:val.col > threshold')

" FUNCTION  StatuslineLongLineWarning()
"     Defined: ~/.homesick/repos/vim-4-eva/vim/plugin/statusline/warn/long-line.vim:10
" Called 1171 times
" Total time:   0.631461
"  Self time:   0.028641

" count  total (s)   self (s)
"  1171              0.004809   if !exists("b:statusline_long_line_warning")
"     9              0.000013     if !&modifiable
"                                   let b:statusline_long_line_warning = ''
"                                   return b:statusline_long_line_warning
"     9              0.000006     endif
"     9   0.602435   0.000075     let long_lines = s:LongLines()
"     9              0.000026     if len(long_lines) > 0
"     9   0.000543   0.000083       call s:LongLineColorColumn()
"     9              0.000056       let b:statusline_long_line_warning = "[" . 'Ł➤' . len(long_lines) . "]"
"                                 else
"                                   let b:statusline_long_line_warning = ""
"     9              0.000006     endif
"  1171              0.000723   endif
"  1171              0.002022   return b:statusline_long_line_warning

" set statusline+=%#warningmsg#
" set statusline+=%{StatuslineLongLineWarning()}
" set statusline+=%*

" TODO is this what is slow???
set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%*

" TODO is this what is slow???
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

" modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

" left/right separator
set statusline+=%=
set statusline+=%#identifier#
"set statusline+=[%03.b][0x%B] " ASCII and byte code under cursor
"set statusline+=%{StatuslineCurrentHighlight()}

" display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%#identifier#
set statusline+=[
set statusline+=%l:%c\ %P                 " cursor column:line position
set statusline+=:%{FileSize()}
set statusline+=%{&ft!=''?':'.&ft:''}     " filetype
set statusline+=]

set laststatus=2

"set statusline=
"set statusline+=%1*  "switch to User1 highlight
"set statusline+=%F   "full filename
"set statusline+=%2*  "switch to User2 highlight
"set statusline+=%y   "filetype
"set statusline+=%3*  "switch to User3 highlight
"set statusline+=%l   "line number
"set statusline+=%*   "switch back to statusline highlight
"set statusline+=%P   "percentage thru file
