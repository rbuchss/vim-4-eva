let NERDTreeShowHidden = 1 " Show hidden files in NerdTree
let NERDTreeIgnore = ['\.svn$', '\.git$', '\.vim-sessions$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&
      \ b:NERDTreeType == "primary") | q | endif

let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMapOpenSplit = 's'

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
 exec 'autocmd filetype nerdtree syn match ' . a:extension
       \ .' #^\s\+.*'. a:extension .'$#'
 exec 'autocmd filetype nerdtree highlight ' . a:extension
       \ .' ctermbg='. a:bg .' ctermfg='. a:fg
       \ .' guibg='. a:bg .' guifg='. a:fg
endfunction

"call NERDTreeHighlightFile('bash', 'green', 'black')
"call NERDTreeHighlightFile('sh', 'green', 'black')
"call NERDTreeHighlightFile('html', 'green', 'black')
"call NERDTreeHighlightFile('css', 'green', 'black')
