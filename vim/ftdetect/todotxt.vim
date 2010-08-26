" Vim filetype detection file
" Language:	todo.txt (http://todotxt.com/)
" Maintainer:	David O'Callaghan <david.ocallaghan@cs.tcd.ie>
" URL:		
" Version:	2
" Last Change:  2010 Aug 23
"
augroup todotxt
     au! BufRead,BufNewFile *.never.txt,todo.txt,*.done.txt,*.todo.txt,recur.txt,done.txt,done_*.txt,tasks.txt setfiletype todotxt
augroup END
