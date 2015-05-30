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
augroup END
" vim:fdm=marker:et:ts=4:
