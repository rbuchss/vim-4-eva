" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

execute mutagen#infect()

" Use pathogen to modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
execute before_pathogen#infect()
execute pathogen#infect()
execute pathogen#helptags()

nnoremap ; :
let g:mapleader = ","         " change the mapleader from \ to ,

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on
set encoding=utf-8
set autoindent                  " always set autoindenting on
set formatoptions-=t            " disable auto adding linebreaks
set modelines=0                 " blocks modelines from being executed
set nomodeline                  " blocks modelines from being executed
set backspace=indent,eol,start  " allow backspacing over everything
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set timeoutlen=500
set ttyfast                     " smoother changes for a fast terminal
set ttyscroll=3
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
" set splitright
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
set tabpagemax=100
set wildmenu                    " Make the command-line completion better
set wildmode=full
set nocursorline                " faster without; needs to be set when first opening a file to work
" set synmaxcol=3000
set synmaxcol=256
syntax sync minlines=256
set nofoldenable
set nrformats=                  " treat all numbers as base 10
" set updatetime=100
set list
set listchars=tab:⮀∎,trail:∎,extends:▲,precedes:▲,nbsp:⌧
set tags=tags,./tags            " for ctags
set omnifunc=syntaxcomplete#Complete
colorscheme Zombat256           " make cursor and status line purdy

set guioptions-=m               " menu bar
set guioptions-=T               " toolbar
set guioptions-=r               " scrollbar

execute mutagen#mutate()
