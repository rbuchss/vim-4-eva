" Vim color file

" For some reason gvim bugs out with this setting and makes the background light ...
if !has("gui_running")
  set background=dark
endif

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name = "Zombat256"

" General colors
hi Normal         ctermfg=252           ctermbg=NONE          cterm=NONE          guifg=#e3e0d7       guibg=#242424       gui=NONE
hi Cursor         ctermfg=234           ctermbg=228           cterm=NONE          guifg=#242424       guibg=#eae788       gui=NONE
hi Visual         ctermfg=251           ctermbg=239           cterm=NONE          guifg=#c3c6ca       guibg=#554d4b       gui=NONE
hi VisualNOS      ctermfg=251           ctermbg=236           cterm=NONE          guifg=#c3c6ca       guibg=#303030       gui=NONE
hi Search         ctermfg=228           ctermbg=33            cterm=NONE          guifg=#ffff87       guibg=#0087ff       gui=NONE
hi Folded         ctermfg=103           ctermbg=237           cterm=NONE          guifg=#a0a8b0       guibg=#3a4046       gui=NONE
hi Title          ctermfg=83            ctermbg=NONE          cterm=bold          guifg=#ffffd7       guibg=NONE          gui=bold
"hi Title         ctermfg=202           ctermbg=NONE          cterm=bold          guifg=#ffffd7       guibg=NONE          gui=bold
hi StatusLine     ctermfg=230           ctermbg=238           cterm=NONE          guifg=#ffffd7       guibg=#444444       gui=NONE
hi VertSplit      ctermfg=238           ctermbg=238           cterm=NONE          guifg=#444444       guibg=#444444       gui=NONE
hi StatusLineNC   ctermfg=241           ctermbg=238           cterm=NONE          guifg=#857b6f       guibg=#444444       gui=NONE
hi LineNr         ctermfg=241           ctermbg=NONE          cterm=NONE          guifg=#857b6f       guibg=NONE          gui=NONE
hi SpecialKey     ctermfg=241           ctermbg=235           cterm=NONE          guifg=#626262       guibg=#2b2b2b       gui=NONE
hi WarningMsg     ctermfg=203           ctermbg=NONE          cterm=NONE          guifg=#ff5f55       guibg=NONE          gui=NONE
hi ErrorMsg       ctermfg=196           ctermbg=236           cterm=bold          guifg=#ff2026       guibg=#3a3a3a       gui=bold

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine   ctermfg=NONE          ctermbg=NONE          cterm=NONE          guifg=NONE          guibg=#32322f       gui=NONE
  hi MatchParen   ctermfg=228           ctermbg=101           cterm=bold          guifg=#eae788       guibg=#857b6f       gui=bold
  hi Pmenu        ctermfg=230           ctermbg=238           cterm=NONE          guifg=#ffffd7       guibg=#444444       gui=NONE
  hi PmenuSel     ctermfg=NONE          ctermbg=192           cterm=NONE          guifg=#080808       guibg=#cae982       gui=NONE
endif

" Diff highlighting
hi DiffAdd        ctermfg=NONE          ctermbg=17            cterm=NONE          guifg=NONE          guibg=#2a0d6a       gui=NONE
hi DiffDelete     ctermfg=234           ctermbg=60            cterm=NONE          guifg=#242424       guibg=#3e3969       gui=NONE
hi DiffText       ctermfg=NONE          ctermbg=53            cterm=NONE          guifg=NONE          guibg=#73186e       gui=NONE
hi DiffChange     ctermfg=NONE          ctermbg=237           cterm=NONE          guifg=NONE          guibg=#382a37       gui=NONE

"hi CursorIM
"hi Directory
"hi IncSearch
"hi Menu
hi ModeMsg        ctermfg=83            ctermbg=NONE          cterm=NONE
hi MoreMsg        ctermfg=103           ctermbg=NONE          cterm=NONE
"hi PmenuSbar
"hi PmenuThumb
"hi Question
"hi Scrollbar
"hi SignColumn
hi SpellBad       ctermfg=203           ctermbg=NONE          cterm=NONE
"hi SpellCap
"hi SpellLocal
"hi SpellRare
"hi TabLine
"hi TabLineFill
"hi TabLineSel
"hi Tooltip
"hi User1
"hi User9
"hi WildMenu

"define 3 custom highlight groups
hi User1          ctermfg=red           ctermbg=green         cterm=NONE          guifg=red           guibg=green         gui=NONE
hi User2          ctermfg=blue          ctermbg=red           cterm=NONE          guifg=blue          guibg=red           gui=NONE
hi User3          ctermfg=green         ctermbg=blue          cterm=NONE          guifg=green         guibg=blue          gui=NONE

" Syntax highlighting
hi Keyword        ctermfg=111           ctermbg=NONE          cterm=NONE          guifg=#88b8f6       guibg=NONE          gui=NONE
hi Statement      ctermfg=111           ctermbg=NONE          cterm=NONE          guifg=#88b8f6       guibg=NONE          gui=NONE
hi Constant       ctermfg=173           ctermbg=NONE          cterm=NONE          guifg=#e5786d       guibg=NONE          gui=NONE
hi Number         ctermfg=173           ctermbg=NONE          cterm=NONE          guifg=#e5786d       guibg=NONE          gui=NONE
hi PreProc        ctermfg=173           ctermbg=NONE          cterm=NONE          guifg=#e5786d       guibg=NONE          gui=NONE
hi Function       ctermfg=192           ctermbg=NONE          cterm=NONE          guifg=#cae982       guibg=NONE          gui=NONE
hi Identifier     ctermfg=192           ctermbg=NONE          cterm=NONE          guifg=#cae982       guibg=NONE          gui=NONE
hi Type           ctermfg=186           ctermbg=NONE          cterm=NONE          guifg=#d4d987       guibg=NONE          gui=NONE
hi Special        ctermfg=229           ctermbg=NONE          cterm=NONE          guifg=#eadead       guibg=NONE          gui=NONE
hi String         ctermfg=113           ctermbg=NONE          cterm=NONE          guifg=#95e454       guibg=NONE          gui=NONE
hi Comment        ctermfg=246           ctermbg=NONE          cterm=NONE          guifg=#9c998e       guibg=NONE          gui=NONE
hi Todo           ctermfg=black         ctermbg=186           cterm=NONE          guifg=#857b6f       guibg=NONE          gui=NONE

" Links
hi! link FoldColumn Folded
hi! link CursorColumn CursorLine
hi! link NonText LineNr

" formating helper:
"   %s/\v\=([^[:space:]]+)([[:space:]]+)/\= submatch(0) . repeat(" ", 15 - len(submatch(0)))/g

" vim: textwidth=180 ts=4 sw=4 noet: 
