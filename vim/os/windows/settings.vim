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

" https://superuser.com/questions/1045290/copy-paste-in-gvim-broken-after-creating-personal-vimrc
if has('gui_running')
  source $VIMRUNTIME/mswin.vim
  behave mswin
endif

" Hotfix to avoid nvim issue with ctrl-Z on windows
" see:
"   https://github.com/neovim/neovim/issues/6660
if has('nvim')
  nmap <C-z> <Nop>
endif
