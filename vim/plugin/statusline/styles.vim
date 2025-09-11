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

" NOTE: The current StatuslineLongLineWarning implementation is very slow so disabling for now
" set statusline+=%#warningmsg#
" set statusline+=%{StatuslineLongLineWarning()}
" set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{LinterStatus()}
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

if has('nvim')
  set statusline+=%#identifier#
  set statusline+=%{v:lua.CustomStatus.ai_status()}
  set statusline+=%*
endif

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
