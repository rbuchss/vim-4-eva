" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen to modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
execute pathogen#infect()
execute pathogen#helptags()

" home brewed functions
source ~/.vim/functions/myfunctions.vim

"----------------------------------------------------------
" settings
"----------------------------------------------------------
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set history=1000              " remember more commands and search history
set undolevels=1000           " use many muchos levels of undo
set timeoutlen=500
set ruler                     " show the cursor position all the time
set nospell
set showcmd                   " display incomplete commands
set incsearch                 " do incremental searching
set title                     " change the terminal's title
set guifont=Courier\ New      " much nicer font
set nobackup                  " no more stupid ~ files
set dir=~/.swp,/tmp,/var/tmp  " don't polute swps
set clipboard+=unnamed         " use windows/osx clipboard with yank and paste
set nowrap                    " no line wrap
set noerrorbells              " don't beep
set visualbell                " don't beep
set number                    " always show line numbers
set showmatch                 " set show matching parenthesis
set expandtab
set softtabstop=2             " let's be good ruby citizens
set shiftwidth=2              " let's be good ruby citizens
set wildmenu                  " Make the command-line completion better
set cursorline                " faster without
set nrformats=                 " treat all numbers as base 10
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
autocmd filetype html,xml set listchars-=tab:>.

" for ctags
set tags=tags;/

filetype plugin on
set omnifunc=syntaxcomplete#Complete

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  "set ttymouse=xterm2
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

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
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END
else
  set autoindent    " always set autoindenting on
  set copyindent    " copy the previous indentation on autoindenting
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

"set printexpr=system('gtklp'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error

let python_highlight_all = 1

let g:netrw_dirhistmax=0

"----------------------------------------------------------
" mapping goodness
"----------------------------------------------------------
" makes Ex = 2xEx
nnoremap ; :
let mapleader=","           " change the mapleader from \ to ,

map <C-t> :tabnew<CR>
map <T-Right> :tabn<CR>
map <T-Left> :tabp<CR>
map <S-Up> :wincmd k<CR>
map <S-Down> :wincmd j<CR>
map <S-Left> :wincmd h<CR>
map <S-Right> :wincmd l<CR>

set pastetoggle=<leader>pt
map <F5> :buffers<CR>:b!

" reset search highlighting
nmap <silent> <leader>/ :nohlsearch<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" toggle spell check
map <silent> <leader>st :setlocal spell! spelllang=en_us<CR>

" Don't use Ex mode, use Q for formatting
map Q gq

"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" The following beast is something i didn't write... it will return the 
" syntax highlighting group that the current "thing" under the cursor
" belongs to -- very useful for figuring out what to change as far as 
" syntax highlighting goes.
nmap <silent> ,qq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"----------------------------------------------------------
" mouse toggle
"----------------------------------------------------------
fun! s:ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
        set number
        echo "Mouse is for Vim (" . &mouse . ")"
    else
        let s:old_mouse = &mouse
        let &mouse=""
        set nonumber
        echo "Mouse is for terminal"
    endif
endfunction

noremap <leader>mt :call <SID>ToggleMouse()<CR>
inoremap <leader>mt <Esc>:call <SID>ToggleMouse()<CR>a

"----------------------------------------------------------
" make cursor and status line purdy
"----------------------------------------------------------
colorscheme Zombat256

" change cursor shape between modes
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"statusline setup
set statusline =%#identifier#
"set statusline+=[%t]    "tail of the filename
set statusline+=[%f]    "relative path is better
set statusline+=%*

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype

"read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

"modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"set stl=%f\ %m\ %r%{fugitive#statusline()}\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]

"----------------------------------------------------------
" for nerdtree plugin
"----------------------------------------------------------
let NERDTreeShowHidden=1 "Show hidden files in NerdTree
let NERDTreeIgnore=['\.svn$','\.git$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <silent> <leader>nt :NERDTreeTabsToggle<CR>
map <silent> <C-n> :NERDTreeTabsToggle<CR>

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:bg .' guifg='. a:fg
endfunction

"call NERDTreeHighlightFile('bash', 'green', 'black')
"call NERDTreeHighlightFile('sh', 'green', 'black')
"call NERDTreeHighlightFile('html', 'green', 'black')
"call NERDTreeHighlightFile('css', 'green', 'black')

"-----------------------------------------------------------------------------
" Fugitive; vim + git
"-----------------------------------------------------------------------------
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \  noremap <buffer> .. :edit %:h<cr> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete

nmap <leader>gs :Gstatus<cr>
nmap <leader>ge :Gedit<cr>
nmap <leader>gw :Gwrite<cr>
nmap <leader>gr :Gread<cr>

"-----------------------------------------------------------------------------
" Gundo stuff
"-----------------------------------------------------------------------------
nmap <silent> <leader>ut :GundoToggle<CR>

"-----------------------------------------------------------------------------
" for tagbar
"-----------------------------------------------------------------------------
nmap <silent> <leader>tt :TagbarToggle<CR>

"-----------------------------------------------------------------------------
" haz vimdiff ignore whitespace
"-----------------------------------------------------------------------------
"if &diff
"    " diff mode
"    set diffopt+=iwhite
"endif

"-----------------------------------------------------------------------------
" add syntax coloring for new filetypes
"-----------------------------------------------------------------------------
au BufNewFile,BufRead *.rabl set filetype=ruby
au BufNewFile,BufRead *.pill set filetype=ruby

au BufNewFile,BufRead *.kjb set filetype=xml
au BufNewFile,BufRead *.ktr set filetype=xml

"set ff=unix
