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

" Create specific settings depending on the calling program name
if v:progname == "vimm"
    color morning
endif

" TODO: This should only be set for rst or text files
nmap <Leader>ti yyPVr=yyjpo<CR>
nmap <Leader>h1 yypVr=o<CR>
nmap <Leader>h2 yypVr-o<CR>
nmap <Leader>h3 yypVr~o<CR>

"TODO: This should probably be set somewhere else.
augroup experiment

    au!
    " When opening a file, go to the last known position when the file was last
    " open.
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

augroup END

" Reload this configuration file automatically when it is changed within Vim
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc nested
        \ so $MYVIMRC |
        \ if has('gui_running') && !empty($MYGVIMRC) |
        \     so $MYGVIMRC |
        \ endif |
        \ so <sfile>:p |
        \ filetype detect |
        \ echo '<sfile>:t has been reloaded after saving it'
augroup END

" Function and command to open a tag in a new tab (I'm always doing this
" manually).
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
" vim:fdm=marker:et:ts=4:
