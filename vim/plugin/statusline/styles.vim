" statusline setup
set statusline=%#identifier#
set statusline+=%{GitStatusline()}

set statusline+=%#identifier#
set statusline+=%h

" read only flag
set statusline+=%#warningmsg#
set statusline+=%{ReadOnlyFlag()}
set statusline+=%*

set statusline+=%#identifier#
set statusline+=[%-.100f]    "relative path is better than tail %t option
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineLongLineWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%*

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
"set statusline+=[%03.b][0x%B] " ASCII and byte code under cursor
set statusline+=%{StatuslineCurrentHighlight()}
set statusline+=%#identifier#
set statusline+=%{&ft!=''?'['.&ft.']':''}     "filetype

" display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

"set statusline+=%#identifier#
"set statusline+=[%{FileSize()}]

set statusline+=%#identifier#
set statusline+=[%c:%l\ %P]     " cursor column:line position

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