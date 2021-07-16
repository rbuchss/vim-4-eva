" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!
  " For all files set 'textwidth' to 128 characters.
  autocmd FileType * setlocal textwidth=80
  " only auto enable spelling for these few types
  autocmd FileType svn,*commit* setlocal spell
  autocmd FileType help setlocal nospell
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost * call SetCursorPosition()
  augroup END
else
  set autoindent    " always set autoindenting on
  set copyindent    " copy the previous indentation on autoindenting
endif " has("autocmd")
