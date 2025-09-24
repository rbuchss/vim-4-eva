" Only do this part when compiled with support for autocommands.
" TODO: double check if this is needed for indent config.
" This is verbatium of the old autocmd.vim setup.
"
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
else
  set autoindent    " always set autoindenting on
  set copyindent    " copy the previous indentation on autoindenting
endif
