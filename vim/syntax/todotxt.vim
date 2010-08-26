" Vim syntax file
" Language:    todo.txt
" Maintainer:    Graham Davies <gpd@grahamdavie.net>
" Filenames:    todo.txt *.todo
" Last Change:  2010-08-23  

" Install this file in ~/.vim/syntax/todotxt.vim
" Add the following line to ~/.vim/ftdetect/todotxt.vim
" au BufRead,BufNewFile todo.txt,*.todo.txt,recur.txt,*.todo setfiletype
" todotxt

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" todotxt.com todo.txt compatible
"syn match    todoDate    /([^]]\+)/ 
"syn match    todoDone      /^x .*/           contains=todoProject,todoContext,todoDate,todoAssignee,todoPriority
"syn match    todoFoldProject      /-\S\+/
syn match       todoAssignee      "\[[^]]\+\]"                     
syn match       todoContext       /\s\?@\S\+/                     
syn match       todoDate          /([0-9]\+)/                     
syn match       todoDate          /(\d\+\/\d\+ \d\+:\d\+)/        
syn match       todoDate          /(\d\+\/\d\+)/                  
syn match       todoDate          /(\d\+\/\d\+\/\d\+ \d\+:\d\+)/  
syn match       todoDate          /(\d\+\/\d\+\/\d\+)/            
syn match       todoDefer         /_\w\+/           
syn match       todoDone          /^\s*x .*/        
syn match       todoLabel         /%\S\+%/ 
syn match       todoNever         /^\s*o .*/        
syn match       todoPriority      /([A-Z])/
syn match       todoPriority      /[*!][A-Z0-9]/
syn match       todoProject       /+\S\+/                         
syn match       todoProject       /\s[p][:]\w\{2,}/               
syn match       todoRACI          /\s[RACI][:]\S\{2,}/            
syn match       todoRecur         "{[^}]\+}" 

" Regular text file stuff
syn match       todoBold          /\*[^*]\+\*/
syn match       todoComment       "\s#.*"             
syn match       todoComment       "^#.*"              
syn match       todoEmail         "\S\+@\S\+\.\S\+" 
syn match       todoURI           "\w\+://\S\+" 
syn match       todoUline         /_[^_]\{2,}_/
syn region      todoString        start=/"/ skip=/\\"/ end=/"/ 

" Generic English action words that might be useful

" Own thinking / actions
syn keyword todoVerb learn
syn keyword todoVerb buy
syn keyword todoVerb get
syn keyword todoVerb try
syn keyword todoVerb send
syn keyword todoVerb watch
syn keyword todoVerb setup
syn keyword todoVerb download

" Interact / Consult with someone else 
syn keyword todoVerb ask
syn keyword todoVerb confirm
syn keyword todoVerb chase
syn keyword todoVerb decide
syn keyword todoVerb organise
syn keyword todoVerb book
syn keyword todoVerb meet
syn keyword todoVerb arrange

" Research existing thing
syn keyword todoVerb check
syn keyword todoVerb read
syn keyword todoVerb review
syn keyword todoVerb research
syn keyword todoVerb find
syn keyword todoVerb search
syn keyword todoVerb identify
syn keyword todoVerb investigate

" Create new thing
syn keyword todoVerb create
syn keyword todoVerb design
syn keyword todoVerb prepare
syn keyword todoVerb implement
syn keyword todoVerb make
syn keyword todoVerb report
syn keyword todoVerb draft
syn keyword todoVerb write

" Modify existing
syn keyword todoVerb wash
syn keyword todoVerb fix
syn keyword todoVerb clean
syn keyword todoVerb change
syn keyword todoVerb add
syn keyword todoVerb convert

" Modifiers / defer - should be _mabye 
syn keyword todoQuery maybe
syn keyword todoQuery never
syn keyword todoQuery someday

" Questions
syn keyword todoQuery wrt
syn keyword todoQuery for
syn keyword todoQuery could
syn keyword todoQuery why
syn keyword todoQuery what
syn keyword todoQuery does
syn keyword todoQuery how
syn keyword todoQuery if
syn keyword todoQuery shall
syn keyword todoQuery should
syn keyword todoQuery when
syn keyword todoQuery where
syn keyword todoQuery which
syn keyword todoQuery who
syn keyword todoQuery will
syn keyword todoQuery would

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
"
"  :source /usr/share/vim/vim71/syntax/hitest.vim
"
if version >= 508 || !exists("did_conf_syntax_inits")
  if version < 508
    let did_todo_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " MatchParen White on Cyan
  " Constant Red
  " Special  Purple
  " Identifier Cyan
  " Statement Yellow
  " PreProc Purple
  " Type Green
  " Underlined Purple underlined
  " CursorLine White underlined
  " Ignore White bold
  " Error White on Red
  " Todo Black on Yellow
  " Normal 

  HiLink todoAssignee       Number
  hi todoBold term=bold cterm=bold gui=bold
  HiLink todoCommand        Special
  HiLink todoComment        Comment
  HiLink todoContext        Statement
  HiLink todoDate           PreProc
  HiLink todoDefer          Type
  HiLink todoDone           NonText
  HiLink todoEmail          Underlined
  HiLink todoFoldProject    PreProc
  HiLink todoLabel          Todo
  HiLink todoNever          Comment
  hi todoPriority term=bold cterm=bold gui=bold
  HiLink todoProject        Identifier
  HiLink todoQuery          Constant
  HiLink todoRACI           PreProc
  HiLink todoRecur          Constant
  HiLink todoString         Question 
  HiLink todoURI            Underlined 
  HiLink todoUline          CursorLine
  HiLink todoVerb           Type

  syn region todotxtPriA matchgroup=todotxtPriA start=/^\s*\((A)\)\|[*!]\+A / end=/$/ contains=ALL
  syn region todotxtPriB matchgroup=todotxtPriB start=/^\s*\((B)\)\|[*!]\+B / end=/$/ contains=ALL
  syn region todotxtPriC matchgroup=todotxtPriC start=/^\s*\((C)\)\|[*!]\+C / end=/$/ contains=ALL
  syn region todotxtPriD matchgroup=todotxtPriD start=/^\s*\((D)\)\|[*!]\+D / end=/$/ contains=ALL
  hi todotxtPriA ctermfg=DarkYellow guifg=DarkYellow
  hi todotxtPriB ctermfg=Green guifg=Green
  hi todotxtPriC ctermfg=Blue guifg=Blue
  hi todotxtPriD ctermfg=grey guifg=grey

  delcommand HiLink
endif

let b:current_syntax = "todotxt"

" vim: ts=8 sw=2
