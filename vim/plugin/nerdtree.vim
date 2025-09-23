let g:NERDTreeShowHidden = 1 " Show hidden files in NerdTree
let g:NERDTreeIgnore = ['\.svn$[[dir]]', '\.git$[[dir]]']

let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMapOpenSplit = 's'

autocmd bufenter * if (
    \   winnr("$") == 1
    \   && exists("b:NERDTreeType")
    \   && b:NERDTreeType == "primary"
    \ ) | q | endif

"call ext#nerdtree#HighlightFile('bash', 'green', 'black')
"call ext#nerdtree#HighlightFile('sh', 'green', 'black')
"call ext#nerdtree#HighlightFile('html', 'green', 'black')
"call ext#nerdtree#HighlightFile('css', 'green', 'black')
