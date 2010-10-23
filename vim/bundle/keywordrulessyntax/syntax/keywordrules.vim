" Vim syntax file
" Language:	keywordrules
" Maintainer:	Jacobo de Vera <devel@jacobodevera.com>
" Filenames:	*.kwr
" Last Change:	Feb 14, 2010

" Install this file in ~/.vim/syntax/todo.vim
" Add the following line to ~/.vim/ftdetect/keywordrules.vim
" au BufRead,BufNewFile *.kwr set filetype=keywordrules

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif


syn match   kwrOrigKeyword  "^[^:]\+"
syn match   kwrDelete  "\([:,]\s*\)\@<=-[^,]*" contains=kwrSymbol
syn match   kwrSymbol  "-" contained
syn match   kwrSymbol  "\s+"
syn match   kwrComment "^\s*#.*$"



hi def link kwrOrigKeyword     Special
hi def link kwrDelete          Macro
hi def link kwrSymbol          Number
hi def link kwrComment         Comment


let b:current_syntax = "keywordrules"
