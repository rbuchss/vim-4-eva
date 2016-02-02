"-----------------------------------------------------------------------------
" autosave and autoload session if one exists
"-----------------------------------------------------------------------------
nmap <leader>zi :call InitZession()<CR>

function! InitZession()
  execute 'mksession! ' . getcwd() . '/.zession.vim'
endfunction

"autocmd VimLeave * call SaveZession()
"function! SaveZession()
"  if &ft != 'gitcommit' && filereadable(getcwd() . '/.zession.vim')
"    call InitZession()
"  endif
"endfunction

autocmd VimEnter * call RestoreZession()
function! RestoreZession()
  if argc() == 0
    if filereadable(getcwd() . '/.zession.vim')
      execute 'so ' . getcwd() . '/.zession.vim'
      if bufexists(1)
        for l in range(1, bufnr('$'))
          if bufwinnr(l) == -1
            exec 'sbuffer ' . l
          endif
        endfor
      endif
    endif
  endif
endfunction
