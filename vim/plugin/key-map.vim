" NOTE: How to find keystroke sent to vim/nvim
" 1. switch to normal mode
" 2. press :
" 3. press <C-k>
" 4. press chord you want to map and nvim/vim will display the keystroke it received

" lazy shift key helpers
" https://superuser.com/questions/1060424/how-can-i-permanently-map-the-vim-command-w-to-w
command WQ wq
command WA wa
command Wq wq
command Wa wa
command W w
command -bang Q q
command -bang QA qa
command -bang Qa qa

" tab shortcuts
map <leader>tn :tabnew<CR>
map <leader>tc :tabclose<CR>

if has('nvim')
    map <M-Right> :tabn<CR>
    map <M-Left> :tabp<CR>
else
    map <T-Right> :tabn<CR>
    map <T-Left> :tabp<CR>
endif
" fix for osx option-command chord in tmux 2.1
" used `sed -n l` to find the chord key code
map <ESC>[1;3C :tabn<CR>
map <ESC>[1;3D :tabp<CR>
map <S-Up> :wincmd k<CR>
map <S-Down> :wincmd j<CR>
map <S-Left> :wincmd h<CR>
map <S-Right> :wincmd l<CR>

set pastetoggle=<leader>pt
map <F5> :buffers<CR>:b!

" reset search highlighting
nmap <leader>/ :nohlsearch<CR>

" Quickly edit/reload the vimrc file
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :so $MYVIMRC<CR>

" TODO make lang switchable
" toggle spell check
map <leader>st :setlocal spell! spelllang=en_us<CR>

" toggle line wrap
map <leader>wt :setlocal wrap!<CR>

" removes all trailing whitespace
nmap <leader>sw :call StripTrailingWhitespace()<CR>

" Don't use Ex mode, use Q for formatting
map Q gq

" This allows for change paste motion cp{motion}
" so replace word with current buffer would be cpw
" 3 words would be cp3w
" rest of line would be cp$ and so on...
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Mac OS X clipboard integration
nmap <F3> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
vmap <F4> :w !pbcopy<CR><CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" ctag helpers
" from https://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks
" map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" map <M-]> :vsplit <CR>:exec("tag ".expand("<cword>"))<CR>
map <M-]>t :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <M-]>v :vsplit <CR>:exec("tag ".expand("<cword>"))<CR>
map <M-]>s :split <CR>:exec("tag ".expand("<cword>"))<CR>
