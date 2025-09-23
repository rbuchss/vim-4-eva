" NERDTress File highlighting
function! ext#nerdtree#HighlightFile(extension, fg, bg) abort
    exec 'autocmd filetype nerdtree syn match ' . a:extension
          \ .' #^\s\+.*'. a:extension .'$#'
    exec 'autocmd filetype nerdtree highlight ' . a:extension
          \ .' ctermbg='. a:bg .' ctermfg='. a:fg
          \ .' guibg='. a:bg .' guifg='. a:fg
endfunction
