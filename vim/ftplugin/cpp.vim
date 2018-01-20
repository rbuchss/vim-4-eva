" https://stackoverflow.com/questions/18158772/how-to-add-c11-support-to-syntastic-vim-plugin
"
" see: vim/bundle/syntastic/syntax_checkers/cpp/gcc.vim
"
" let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_check_header = 1
" let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

" comments default: s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-"
set comments=sl:/**,mb:\ *,elx:\ */

map <F6> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

if has('cscope')
  nmap <C-@><C-@> :cs find s <C-R>=expand("<cword>")<CR><CR>
  "
  " if has('quickfix')
  "   set cscopequickfix=s-,c-,d-,i-,t-,e-
  " endif

  function! LoadCscope()
    " let db = findfile("cscope.out", ".;")
    let db = findfile("cscope.out", ".git;")
    if (!empty(db))
      " let path = strpart(db, 0, match(db, "/cscope.out$"))
      set nocscopeverbose " suppress 'duplicate connection' error
      exe "cs add " . db
      " exe "cs add " . db . " " . path
      set cscopeverbose
      " set cscopetag cscopeverbose
      " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
    endif
  endfunction
  au BufEnter /* call LoadCscope()
endif
