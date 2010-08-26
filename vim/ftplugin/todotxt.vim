" CopyTag: Searches for tags in todo.txt files
" Author: Graham Davies <graham@grahamdavies.net>
"
" Tags are defined as +noSpace and can be several +tag1 +tag2 +tag3
" Function should extract tag from surrounding text
" (10/01) +tag description
" should find +tag from above line
function! s:CopyTag()
    let regex = '\(+\S\+\s\?\)\{1,}'
    let lineNum = line('.')
    let line = getline('.')
    let tagline = search(regex, 'cbn')
	if lineNum == tagline
		echo "Error: Line already has tag"
		return 
	endif
    let tagLineTxt = getline(tagline)
    let tag = matchstr(tagLineTxt,regex)
    let tag = substitute(tag,'\s\+$','','')
    execute "normal I" . tag . " "
endfunction

command! -nargs=0 -bar CopyTag :call <SID>CopyTag()

" Copy Date
function! s:CopyDate()
    let regex = '(\d\+\/\d\+)'
    let lineNum = line('.')
    let line = getline('.')
    let tagline = search(regex, 'cbn')
	if lineNum == tagline
		echo "Error: Line already has tag"
		return 
	endif
    let tagLineTxt = getline(tagline)
    let tag = matchstr(tagLineTxt,regex)
    let tag = substitute(tag,'\s\+$','','')
    execute "normal I" . tag . " "
endfunction

command! -nargs=0 -bar CopyDate :call <SID>CopyDate()

" DueDate: Searches for tags in todo.txt files
" Author: Graham Davies <graham@grahamdavies.net>
"
" Allows you to enter :DueDate <args>
" Where <args> is the number of days before task is due
"
function! s:DueDate(days)
    let when = 3600 * 24 * a:days
    let yearDue = strftime("%Y", localtime() + when)
    if yearDue != strftime("%Y", localtime())
        let format = "(%Y/%m/%d)"
    else
        let format = "(%m/%d)"
    endif
    let due = strftime(format, localtime() + when)

    execute "normal I" . due . " "
endfunction

command! -nargs=1 DueDate :call <SID>DueDate(<f-args>)

" DueNow: Searches for tasks that are due
"

function! s:MarkDue()
    let pattern = '(\([01][0-9]\)\/\([0123][0-9]\))'
    let line    = search(pattern, 'wc')
    let dueDate = matchlist(getline(line),pattern)
    let dueMonth = dueDate[1]
    let dueDay  = dueDate[2]
    let nowMonth = strftime("%m", localtime())
    let nowDay   = strftime("%d", localtime())
    let nowYear  = strftime("%Y", localtime())
    echo getline(line)
    let due = ''
    if dueMonth < nowMonth 
        let due = 'yes'
        echo "omg"
    endif
    if dueMonth == nowMonth 
        if dueDay <= nowDay
            echo "due"
            let due = 'yes'
        endif
    endif
    if due == 'yes'
        let priority = "!A "
        " Check for existing priority
        let status = match(getline(line),priority)
        if status == -1
            execute "normal I" . priority
            echo "added"
        else
            echo "Already priority " . status
        endif
    endif
endfunction

command! -nargs=0 MarkDue :call <SID>MarkDue()

" TodoDone: Completes a task according to todo.txt syntax
"
" Adds "x 2009-10-13 17:18 " to the start of a task to show completion
" Adding an argument gives number of days in the past when done
"
function! s:TodoDone(...)
    let when = 3600 * 24 * a:0
    let format = "%Y-%m-%d %H:%M "
    let doneDate = strftime(format, localtime() - when)
    execute "normal I" . "x " . doneDate
endfunction                                   

command! -nargs=? TodoDone :call <SID>TodoDone(<f-args>)

" Add a tag
map  [t   $:CopyTag<CR>
vmap [t   $:CopyTag<CR>

" Mark a task as done
map  [d   :TodoDone<CR>
vmap [d   :TodoDone<CR>

map  [j   $:CopyTag<CR>:CopyDate<CR>:TodoDone<CR>
vmap [j   $:CopyTag<CR>:CopyDate<CR>::TodoDone<CR>

" Clear away indented done lines
map  [c   :set lazyredraw<CR>kmrj/^\s\+x <CR>ddGp:s/^\s\+//<CR>'r:nohlsearch<CR>

" Other macros
map  [w   :DueDate 7<CR>
vmap [w   :DueDate 7<CR>
map  [m   :DueDate 30<CR>
vmap [m   :DueDate 30<CR>
map  [s   :%IndentSort<CR>
vmap [s   :%IndentSort<CR>
map  [r   zRmr:%RecursiveIndentSort<CR>'r
vmap [r   zRmr:%RecursiveIndentSort<CR>'r

" abbreviations
" can put these in .vimrc if useful for other file types
iab ddate <c-r>=strftime("%Y-%m-%d")<cr>
iab xdate <c-r>=strftime("%Y-%m-%d %H:%M")<cr>
iab tdate <c-r>=strftime("(%m/%d)")<cr>
"iab 7date <c-r>=strftime("(%m/%d)", localtime() + 3600*24*7)<cr>
"iab 1date <c-r>=strftime("(%m/%d)", localtime() + 3600*24*1)<cr>
"iab 2date <c-r>=strftime("(%m/%d)", localtime() + 3600*24*2)<cr>

iab 1days   <c-r>=substitute(system('date --date="+ 1 days"            +\(%m/%d\)'),"\\n","","")<cr>
iab 2days   <c-r>=substitute(system('date --date="+ 2 days"            +\(%m/%d\)'),"\\n","","")<cr>
iab 3days   <c-r>=substitute(system('date --date="+ 3 days"            +\(%m/%d\)'),"\\n","","")<cr>
iab 4days   <c-r>=substitute(system('date --date="+ 4 days"            +\(%m/%d\)'),"\\n","","")<cr>
iab 5days   <c-r>=substitute(system('date --date="+ 5 days"            +\(%m/%d\)'),"\\n","","")<cr>
iab 6days   <c-r>=substitute(system('date --date="+ 6 days"            +\(%m/%d\)'),"\\n","","")<cr>
iab 7days   <c-r>=substitute(system('date --date="+ 7 days"            +\(%m/%d\)'),"\\n","","")<cr>
iab nmon    <c-r>=substitute(system('date --date="next monday"         +\(%m/%d\)'),"\\n","","")<cr>
iab ntue    <c-r>=substitute(system('date --date="week tuesday"      +\(%m/%d\)'),"\\n","","")<cr>
iab nwed    <c-r>=substitute(system('date --date="week wednesday"      +\(%m/%d\)'),"\\n","","")<cr>
iab eotw    <c-r>=substitute(system('date --date="next friday"         +\(%m/%d\)'),"\\n","","")<cr>
iab eonw    <c-r>=substitute(system('date --date="week friday"         +\(%m/%d\)'),"\\n","","")<cr>
iab 2weeks  <c-r>=substitute(system('date --date="+ 14 days"           +\(%m/%d\)'),"\\n","","")<cr>
iab 3weeks  <c-r>=substitute(system('date --date="+ 21 days"           +\(%m/%d\)'),"\\n","","")<cr>
iab 2months <c-r>=substitute(system('date --date="+ 60 days"           +\(%m/%d\)'),"\\n","","")<cr>
iab 3months <c-r>=substitute(system('date --date="+ 90 days"           +\(%m/%d\)'),"\\n","","")<cr>
iab eotm    <c-r>=substitute(system('date --date="next month - 1 day"  +\(%m/%d\)'),"\\n","","")<cr>
iab eoty    <c-r>=substitute(system('date --date="next year"           +\(%Y/%m/%d\)'),"\\n","","")<cr>

