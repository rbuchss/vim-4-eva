" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

nnoremap ; :
let g:mapleader = ' '         " change the mapleader from \ to <space>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has('gui_running')
  syntax on
  set hlsearch
endif

filetype plugin on
set encoding=utf-8
set autoindent                  " always set autoindenting on
set breakindent                 " Enable break indent
set formatoptions-=t            " disable auto adding linebreaks
set formatoptions+=w            " useful to split long lines with 'gq' cmd
                                " witout nuking existing line breaks
set fileformat=unix
set fileformats=unix,dos
set modelines=0                 " blocks modelines from being executed
set nomodeline                  " blocks modelines from being executed
set backspace=indent,eol,start  " allow backspacing over everything
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set undofile                    " Save undo history
set timeoutlen=500
set updatetime=250

if has('nvim')
set inccommand=split            " Preview substitutions live, as you type!
else
set ttyfast                     " smoother changes for a fast terminal
                                " for nvim is always set and option is removed
set ttyscroll=3
endif

" if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
" instead raise a dialog asking if you wish to save the current file(s)
" See `:help 'confirm'`
set confirm

set lazyredraw
set ruler                       " show the cursor position all the time
set nospell
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set ignorecase                  " case-insensitive search
set smartcase                   " case-sensitive search if any caps
set title                       " change the terminal's title
set nobackup                    " no more stupid ~ files
set clipboard+=unnamed          " use windows/osx clipboard with yank and paste
set nowrap                      " no line wrap
set splitbelow
set nosplitright
set noerrorbells                " don't beep
set novisualbell                " don't beep
set number                      " always show line numbers
set showmatch                   " set show matching parenthesis
set expandtab
set scrolloff=3                 " show context above/below cursorline
set sidescrolloff=3
set tabstop=8                   " actual tabs occupy 8 characters
set softtabstop=2               " let's be good ruby citizens
set shiftwidth=2                " let's be good ruby citizens
set tabpagemax=200
set wildmenu                    " Make the command-line completion better
set wildmode=full
set nocursorline                " faster without; needs to be set when first opening a file to work
" set synmaxcol=3000
set synmaxcol=256
syntax sync minlines=256
set nofoldenable
set nrformats=                  " treat all numbers as base 10
set list
set listchars=tab:\|\ ,trail:∎,extends:»,precedes:«,nbsp:⌧
set tags=tags,./tags            " for ctags
set omnifunc=syntaxcomplete#Complete
colorscheme Zombat256           " make cursor and status line purdy

set guioptions-=m               " menu bar
set guioptions-=T               " toolbar
set guioptions-=r               " scrollbar

let g:use_diagnotic_nerd_font_signs = 1
let g:vim_4_eva_diagnostic_sign_error = '✗'
let g:vim_4_eva_diagnostic_sign_warning = ''
let g:vim_4_eva_diagnostic_sign_info = ''
let g:vim_4_eva_diagnostic_sign_hint = ''

" Add vim specific plugins here from vim/pack/{label}/opt.
" This is necessary to avoid autolaoding these in neovim.
" Which would happen in the vim/pack/{label}/start directory.
if !has('nvim')
  packadd vim-polyglot
endif

" Use mutagen to load OS specific settings
execute mutagen#mutate()
