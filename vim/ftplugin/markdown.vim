" Markdown task abbreviations (Obsidian-compatible)

function! InsertMarkdownAbbrev(source, target)
  let line = getline('.')
  if line =~# '^ *'.a:source
    return a:target
  endif
  return a:source
endfunction

" Insert task checkboxes with abbreviations
" Standard markdown only recognizes [ ] and [x], so we use labels for other states
iabbrev <expr> <buffer> todo InsertMarkdownAbbrev('todo', '- [ ]')
iabbrev <expr> <buffer> done InsertMarkdownAbbrev('done', '- [x]')
iabbrev <expr> <buffer> nope InsertMarkdownAbbrev('nope', '- [x] `NOPE`')
iabbrev <expr> <buffer> moved InsertMarkdownAbbrev('moved', '- [x] `MOVED`')
iabbrev <expr> <buffer> wip InsertMarkdownAbbrev('wip', '- [ ] `WIP`')
iabbrev <expr> <buffer> quest InsertMarkdownAbbrev('quest', '- [ ] `?`')

" Date stamp - useful for journal entries
iabbrev <expr> <buffer> ddd InsertMarkdownAbbrev('ddd', strftime('%Y-%m-%d'))
