" ---------------------------------------------------------------------------
"                          Experimental Vim settings
" ---------------------------------------------------------------------------
" CollectedBy: Jacobo de Vera
" Website:     http://blog.jacobodevera.com
" ---------------------------------------------------------------------------

" {{{ HEX mode function and command
" ----------------------------------------------------------------------------
"
" helper function to toggle hex mode
function! ToggleHex()
    " ---------------------------------------------------------------
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    " ---------------------------------------------------------------
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    " ---------------------------------------------------------------

    if !exists("b:editHex") || !b:editHex

        " save old options
        let b:oldft=&filetype
        let b:oldbin=&binary

        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        let &ft="xxd"

        " set status
        let b:editHex=1

        " switch to hex editor
        %!xxd

    else

        " restore old options
        let &filetype=b:oldft
        if !b:oldbin
          setlocal nobinary
        endif

        " set status
        let b:editHex=0

        " return to normal editing
        %!xxd -r

    endif

    " ---------------------------------------------------------------
    " restore values for modified and read only state
    " ---------------------------------------------------------------
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
    " ---------------------------------------------------------------
endfunction
"
" Command to call the above function, can be used directly in normal mode
command! -bar Hexmode call ToggleHex()
"
"
" ----------------------------------------------------------------------------
" }}}

" Function and command to open a tag in a new tab
function! Tabtag(word)
    echo a:word
    tab split
    exec "tjump " . a:word
endfunction
command! -nargs=1 -complete=tag Tag call Tabtag("<args>")

" A function to reload the contents of a buffer with the output of a command.
" I use this to support custom tools that pipe their output to gview or view.
function! ReloadCommandOutput(cmd)
    se noro
    %d
    exec 'r !' . a:cmd
    1d
    se nomod
    se ro
endfunction

function! GitDiffFoldText()
    let lines = v:foldend - v:foldstart
    let line = getline(v:foldstart)
    let sub = substitute(line, 'diff --git a/\(.\{-}\) b/.*$', '\1', '')
    return printf('-- %4d lines -- %s', lines, sub)
endf

augroup git
    au!
    au FileType git set foldmethod=syntax foldtext=GitDiffFoldText()
    au FileType gitcommit 1 | startinsert!
augroup END


" http://vim.wikia.com/wiki/List_loaded_scripts
function! s:Scratch (command, ...)
   redir => lines
   let saveMore = &more
   set nomore
   execute a:command
   redir END
   let &more = saveMore
   call feedkeys("\<cr>")
   new | setlocal buftype=nofile bufhidden=hide noswapfile
   put=lines
   if a:0 > 0
      execute 'vglobal/'.a:1.'/delete'
   endif
   if a:command == 'scriptnames'
      %substitute#^[[:space:]]*[[:digit:]]\+:[[:space:]]*##e
   endif
   silent %substitute/\%^\_s*\n\|\_s*\%$
   let height = line('$') + 3
   execute 'normal! z'.height."\<cr>"
   0
endfunction
 
command! -nargs=? Scriptnames call <sid>Scratch('scriptnames', <f-args>)
command! -nargs=+ Scratch call <sid>Scratch(<f-args>)

function! s:ChooseFile()
   setlocal cul
   setlocal nomodifiable
   setlocal nomodified
   setlocal readonly
   nnoremap <CR> gf
endfunction

command! -nargs=0 ChooseFile call <sid>ChooseFile()

nnoremap \z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

" LEader l to mark the current line persistently
nnoremap <silent> <Leader>l :exe "let m = matchadd('helpError','\\%" . line('.') . "l')"<CR>

" Highly visible current line
:hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" From Plugin 'sgeb/vim-diff-fold'
" Get fold level for diff mode
" Works with normal, context, unified, rcs, ed, subversion and git diffs.
" For rcs diffs, folds only files (rcs has no hunks in the common sense)
" foldlevel=1 ==> file
" foldlevel=2 ==> hunk
" context diffs need special treatment, as hunks are defined
" via context (after '***************'); checking for '*** '
" or ('--- ') only does not work, as the file lines have the
" same marker.
" Inspired by Tim Chase.
function! DiffFoldLevel()
    let l:line=getline(v:lnum)

    if l:line =~# '^\(diff\|Index\)'     " file
        return '>1'
    elseif l:line =~# '^\(@@\|\d\)'  " hunk
        return '>2'
    elseif l:line =~# '^\*\*\* \d\+,\d\+ \*\*\*\*$' " context: file1
        return '>2'
    elseif l:line =~# '^--- \d\+,\d\+ ----$'     " context: file2
        return '>2'
    else
        return '='
    endif
endfunction

function! DiffFoldText()
    let lines = v:foldend - v:foldstart
    let line = getline(v:foldstart)
    if line =~# '^diff '
       let sub = substitute(line, 'diff \S*\s*\(.\{-}\) .\+$', '\1', '')
    else
       let sub = line
    endif
    return printf('-%s%4d lines: %s', v:folddashes, lines, sub)
endf

augroup aaa
    au FileType diff setlocal foldmethod=expr foldexpr=DiffFoldLevel() foldcolumn=3 foldtext=DiffFoldText()
augroup END


function! WhatFunctionAreWeIn()
  let strList = ["while", "foreach", "ifelse", "if else", "for", "if", "else", "try", "catch", "case"]
  let foundcontrol = 1
  let position = ""
  let pos=getpos(".")          " This saves the cursor position
  let view=winsaveview()       " This saves the window view
  while (foundcontrol)
    let foundcontrol = 0
    normal [{
    call search('\S','bW')
    let tempchar = getline(".")[col(".") - 1]
    if (match(tempchar, ")") >=0 )
      normal %
      call search('\S','bW')
    endif
    let tempstring = getline(".")
    for item in strList
      if( match(tempstring,item) >= 0 )
        let position = item . " - " . position
        let foundcontrol = 1
        break
      endif
    endfor
    if(foundcontrol == 0)
      call cursor(pos)
      call winrestview(view)
      return tempstring.position
    endif
  endwhile
  call cursor(pos)
  call winrestview(view)
  return tempstring.position
endfunction

map <Leader>fu :echo WhatFunctionAreWeIn()<CR>


" vim:fdm=marker:et:ts=4:
