" set noswapfile
" defaults:  .,$TEMP,c:\tmp,c:\temp
" set dir=$TEMP,c:\tmp,c:\temp
set dir=$TEMP,c:/tmp,c:/temp    " don't pollute swps

" set visualbell
" set t_vb=
set belloff=all

set shell=pwsh
set shellcmdflag=-command

set guifont=Consolas

set t_Co=256  " defaults to t_Co=16 for some reason ... which does not support better color schemes