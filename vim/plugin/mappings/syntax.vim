"-----------------------------------------------------------------------------
" return the syntax highlight group under the cursor ''
"-----------------------------------------------------------------------------
" Returns syntax highlighting group the current "thing" under the cursor
nmap <silent> <leader>qq :echo 'stack' . vim_4_eva#syntax#CurrentSynStack() .
      \ ' hi' . vim_4_eva#syntax#CurrentHighlight() .
      \ ' trans' . vim_4_eva#syntax#CurrentTrans() .
      \ ' lo' . vim_4_eva#syntax#CurrentLo() <CR>
