" Vim syntax file
" Language:	todo.txt
" Maintainer:	Graham Davies <gpd@grahamdavie.net>
" Filenames:	todo.txt *.todo
" Last Change:	Dec 01, 2006
" Project:      http://code.google.com/p/todo-py/

" Install this file in ~/.vim/syntax/todo.vim
" Add the following line to ~/.vim/ftdetect/filtype.vim
" au BufRead,BufNewFile todo.txt,*.todo.txt,recur.txt,*.todo set filetype=todo

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" todotxt.com todo.txt compatible
syn match	todoProject	  /+\S\+/
syn match	todoFoldProject	  /-\S\+/
syn match	todoProject	  /\s[p][:-]\w\{2,}/
syn match	todoContext	  /\s\?@\S\+/
syn match	todoPriority	  /([A-Z])/
syn match	todoDone	  /^x .*/ 
syn match	todoDone	  /^\s\+x .*/ 

" Proposed new format for todo.txt -- must be backwards compatible
syn keyword	todoCommand     INCLUDE contained todoComment
"syn match	todoProject	/\s\+\w[:-]\S\+/ " Nasty format a:foo
syn match	todoURI 	"\w\+://\S\+" 
syn match	todoEmail	"\S\+@\S\+\.\S\+" 
syn match	todoDate	"\w\?{[^}]\+}[+=-]\?"
syn match	todoAssignee	/\w\?\[[^]]\+\]/ 
syn match	todoLabel	/\w\?%\S\+%[+=-]\?/ 
syn match	todoCommand	"#INCLUDE"

" Regular text file stuff
syn region	todoString	start=/"/ skip=/\\"/ end=/"/ 
syn match	todoComment	"^#.*" contains=todoCommand
syn match	todoComment	"\s#.*"ms=s+1 contains=todoCommand
syn match       todoBold        /\*[^*]\+\*/
syn match       todoUline       /_[^_]\{2,}_/

" Generic English action words that might be useful
"syn match todoVerb /^\s\{-}write/
"syn match todoVerb /^\s\{-}draft/
"syn match todoVerb /^\s\{-}add/
"syn match todoVerb /^\s\{-}dump/
"syn match todoVerb /^\s\{-}convert/
"syn match todoVerb /^\s\{-}make/
"syn match todoVerb /^\s\{-}find/
"syn match todoVerb /^\s\{-}investigate/
"syn match todoVerb /^\s\{-}research/
"syn match todoVerb /^\s\{-}search/ 
"syn match todoVerb /^\s\{-}decide/
"syn match todoVerb /^\s\{-}think/
"syn match todoVerb /^\s\{-}contemplate/ 
"syn match todoVerb /^\s\{-}book/
"syn match todoVerb /^\s\{-}rent/
"syn match todoVerb /^\s\{-}borrow/ 
"syn match todoVerb /^\s\{-}plan/
"syn match todoVerb /^\s\{-}outline/ 
"syn match todoVerb /^\s\{-}learn/ 
"syn match todoVerb /^\s\{-}get/
"syn match todoVerb /^\s\{-}check/
"syn match todoVerb /^\s\{-}confirm/ 
"syn match todoVerb /^\s\{-}support/
"syn match todoVerb /^\s\{-}implement/ 
"syn match todoVerb /^\s\{-}review/
"syn match todoVerb /^\s\{-}report/
"syn match todoVerb /^\s\{-}summarize/ 
"
"syn match todoQuery /^\s\{-}should/
"syn match todoQuery /^\s\{-}would/
"syn match todoQuery /^\s\{-}could/
"syn match todoQuery /^\s\{-}shall/
"syn match todoQuery /^\s\{-}will/
"syn match todoQuery /^\s\{-}when/
"syn match todoQuery /^\s\{-}who/
"syn match todoQuery /^\s\{-}which/
"syn match todoQuery /^\s\{-}where/
"syn match todoQuery /^\s\{-}whence/
"syn match todoQuery /^\s\{-}how/
"syn match todoQuery /^\s\{-}if/
"syn match todoQuery /^\s\{-}does/
"syn match todoQuery /^\s\{-}which/
"syn match todoQuery /^\s\{-}where/
"syn match todoQuery /^\s\{-}whence/

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_conf_syntax_inits")
  if version < 508
    let did_todo_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink todoProject	    Statement
  HiLink todoFoldProject    PreProc
  HiLink todoContext        Identifier
  HiLink todoQuery          PreProc
  HiLink todoVerb           Identifier
  HiLink todoPriority	    Special
  HiLink todoCommand	    Special
  HiLink todoComment	    Comment
  HiLink todoDone   	    Comment
  HiLink todoTodo	    Todo
  HiLink todoString	    String
  HiLink todoBold           PreProc
  HiLink todoUline          PreProc
  HiLink todoURL	    Type
  HiLink todoLabel    	    Number
  HiLink todoAssignee 	    PreProc
  HiLink todoDate	    Constant
  HiLink todoURI 	    String
  HiLink todoEmail          String
  "HiLink todoCommand       Error
  "HiLink todoCommand	    Conditional

  delcommand HiLink
endif

let b:current_syntax = "todo"

" vim: ts=8 sw=2
