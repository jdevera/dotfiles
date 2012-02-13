" ---------------------------------------------------------------------------
"                           VIM configuration file
" ---------------------------------------------------------------------------
" CollectedBy: Jacobo de Vera
" Website:     http://blog.jacobodevera.com
" ---------------------------------------------------------------------------

" {{{ One setting to rule them all

" This is Vim, not Vi. If I were to use only one setting this would b it.
set nocompatible

" }}}
" {{{ Multiplatform compatibility

if has('win32') || has('win64')

    " Make windows use ~/.vim too, I don't want to use _vimfiles
    set runtimepath^=~/.vim
endif

" }}}
" {{{ Bundle configuration (must precede others)

" Temporarily turn off filetype detection (vundle requirement)
filetype off

" Add vundle to the runtime path
set rtp+=~/.vim/bundle/vundle/

" Call Vundle
call vundle#rc()

" ===========================================================================
" General bundles
" ===========================================================================

" Manage vundle with vundle, oh yeah!
Bundle 'gmarik/vundle'

" Snipmate, dependencies and snippets
Bundle 'tomtom/tlib_vim'          , {'name': 'tlib'}
Bundle 'MarcWeber/vim-addon-mw-utils' , {'name': 'markweber-utils'}
Bundle "garbas/vim-snipmate"      , {'name': 'snipmate'}
Bundle 'honza/snipmate-snippets'

" Surround and repeat (to make the former repeatable)
Bundle 'tpope/vim-repeat'         , {'name': 'repeat'}
Bundle 'tpope/vim-surround'       , {'name': 'surround'}

Bundle 'Align'                    , {'name': 'align'}
Bundle 'camelcasemotion'
Bundle 'Color-Scheme-Explorer'    , {'name': 'cs-explorer'}
Bundle 'Conque-Shell'             , {'name': 'conque-shell'}
Bundle 'davidoc/todo.txt-vim'     , {'name': 'todo-txt'}
Bundle 'godlygeek/csapprox'
Bundle 'hallison/vim-markdown'    , {'name': 'markdown'}
Bundle 'jdevera/vim-stl-syntax'   , {'name': 'stl-syntax'}
Bundle 'majutsushi/tagbar'
Bundle 'pylint.vim'               , {'name': 'pylint'}
Bundle 'python.vim--Vasiliev'     , {'name': 'python-syntax'}
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'ShowMarks'                , {'name': 'showmarks'}
Bundle 'TaskList.vim'             , {'name': 'tasklist'}
Bundle 'tpope/vim-fugitive'       , {'name': 'fugitive'}
Bundle 'tpope/vim-abolish'        , {'name': 'abolish'}
Bundle 'xolox/vim-notes'
Bundle 'matchit.zip'              , {'name': 'matchit'}
Bundle 'mrmargolis/dogmatic.vim'  , {'name': 'dogmatic'}

" ===========================================================================
" Colorschemes
" ===========================================================================

Bundle 'tomasr/molokai'           , {'name' : 'color-molokai'}

" ===========================================================================
" Addons tracked with my dotfiles repository
" ===========================================================================

" Real bash syntax
Bundle! 'bashsyntax'

" Delay colorscheme setting until we know if csapprox is loaded
Bundle! 'colorsetter'

" Load additional local bundles. The local/bundles.vim file, if it exists,
" contains Bundle specs that make sense only in the current machine. That file
" is not tracked. See also the *Local configurations* section below.
if filereadable(expand('~/.vim/local/bundles.vim'))
    execute 'source ' . expand('~/.vim/local/bundles.vim')
endif


" }}}
" {{{ Behaviour?
" ----------------------------------------------------------------------------

" Enables file type specific plugins (with specific indentation)
filetype plugin indent on

" Shows autocomplete menu for commands
set wildmenu

"Completion list settings
" First time tab is hit, complete the longest common string
" Second time tab is hit, list all possible matches
set wildmode=longest,list

"Add additional suffixes to the default (to be ignored)
set suffixes+=,.class,.swp

"Don't tab complete files with these extensions
set wildignore=*.class,*.swp,*.o,*.pyc

" Look for tag files in the same directory of the edited file, and all the way
" up to the root directory (hence the ;)
set tags=./tags;,tags

" Also allow to specify the tags file location through the environment
if $TAGS_DB != "" && filereadable($TAGS_DB)
    set tags+=$TAGS_DB
endif

"Keep cursor in same column when jumping from file to file
set nostartofline

" Set a pdf printer as default printer
set printdevice=pdfprinter

" New windows (vsplit) on the right of the current one
set splitright

" New windows (split) below the current one
set splitbelow

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=4

" ----------------------------------------------------------------------------
" }}}
" {{{ Spacing
" ----------------------------------------------------------------------------

" Number of spaces that a <Tab> in the file counts for.
set tabstop=4

" Number of spaces to use for each step of (auto)indent
set shiftwidth=4

" A <Tab> in front of a line inserts blanks according to shiftwidth
" A <BS> deletes shiftwidth spaces at the start of the line
set smarttab

" Set auto indent, most of the time it annoys me not to have, so I will
" disable it on demand
set autoindent

" Converts tabs into spaces
set expandtab

" In insert mode, allows the backspace key to erase previously entered
" characters
" :help 'backspace'
set backspace=indent,eol,start

" Set the caracters to use when showing tabs and trailing spaces with
" :set list
" Ctrl-K >> for » and Ctrl-K .M for ·  (use :dig for list of digraphs)
set listchars=tab:»»,trail:·

" ----------------------------------------------------------------------------
" }}}
" {{{ Appearance
" ----------------------------------------------------------------------------

"Enables syntax colouring
syntax on


" Set my preferred font for GUI
" -----------------------------------------------
if has('win32') || has('win64')
    set guifont=Lucida\ Console:h12
elseif has('unix')
    set guifont=Monaco\ 10
endif
" -----------------------------------------------


" Remove the GUI tool bar and menubar
" -----------------------------------------------
if has("gui_running")
    set guioptions-=T
    set guioptions-=m
endif


" Allow the use of colours for themes
" -----------------------------------------------
if &term =~ '^\(xterm\|screen\|xterm-color\)$'
    set t_Co=256
endif


" Set a nice colorscheme for GUI and terminal.
" -----------------------------------------------
" Note: These colours are set in an after plug-in called colorschemesetter
let g:my_gui_colorscheme = 'molokai'
let g:my_terminal_colorscheme = 'torte'
let g:my_gui_diff_colorscheme = 'rainbow_fruit'
let g:my_terminal_diff_colorscheme = 'rainbow_fruit'
" -----------------------------------------------


" Show line numbers
set number

" Highlight search terms
set hlsearch

" Show matching brackets
set showmatch

" Show (partial) command in status line
set showcmd



" Highlight lines larger than 120 characters
" -----------------------------------------------
highlight rightMargin term=bold ctermfg=red guifg=red guibg=yellow
match rightMargin /\%<122v.\%>121v/ " Only the 120th char
" match rightMargin /.\%>121v/        " All chars after the 120th
" TODO: Turn this into a map, since changing the colorscheme
"       turns this highlighting off.
" -----------------------------------------------


" Shows the mode (INSERT, VISUAL, REPLACE) in the status bar
" Enabled by default in vim.
" set showmode " Overridden by custom statusline


" Long line indicators
set listchars+=precedes:<,extends:>


" Use a fixed status line that is always visible
set laststatus=2


" Control what information is shown in the status line
" ----------------------------------------------------
" Short version for diffs, to make sure the file name is visible:
"   - Cursor position within the file (row, column)
"   - Percentage of the file where the cursor is now
"   - File length in lines
"   - Path to file
"
" Long version for regular editing:
"   - Newline format (Unix, Windows, Mac)
"   - File type (as recognised by vim, e.g. for syntax highlight)
"   - The ASCII value of the character under the cursor (only in normal mode)
"   - HEX for the ASCII value in the previous field
"   - Cursor position within the file (row, column)
"   - Percentage of the file where the cursor is now
"   - File length in lines
" ----------------------------------------------------
if &diff
    set statusline=[POS=%04l,%04v][%p%%]\ [LEN=%L]\ [F=%F%m%r%h%w]
else
    set statusline=%F%m%r%h%w\ %y\ ff:%{(&ff[0])}\ c:%v\ l:%l\ (%p%%\ of\ %L)
endif
" -----------------------------------------------


" ----------------------------------------------------------------------------
" }}}
" {{{ Key mapping
" ----------------------------------------------------------------------------

" Set , as the map leader (The default \ is hard to type in Spanish keyboards)
let mapleader = ","

" F5 toggles the TagList window (plugin needed)
" N.B.: Although I'd prefer to use C-F3 for this, this key cobination doesn't
"       work when vim is run in gnome-terminal.
silent nnoremap <F5> :TlistToggle<CR>

" <F4> toggles the directory listing window
silent nnoremap <F4> :NERDTreeToggle<CR>

" Shift+Tab shows the list of jumps in the tag stack.
nmap  <C-Tab>  :tags<CR>

" Open the definition in a new tab
nmap <A-/> :tab split<CR>:exec("tjump ".expand("<cword>"))<CR>

" Open the definition in a vertical split
nmap <A-]> :vsp <CR>:exec("tjump ".expand("<cword>"))<CR>

" Offer a choice of tags when several match, jump directly if there is only
" one match.
noremap <C-]> g<C-]>

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> on o<Esc>
nnoremap <silent> On O<Esc>

" Use space to toggle folds
nnoremap <space> za

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Quickly open this file in a split
nmap <Leader>rc :bot split ~/.vimrc<CR>

" Quickly add a new spelling abbreviation to this file.
nmap <F6> :bot split ~/.vimrc<CR>G?LAST_SPELL<CR>zRkoiab<Space>
nmap <C-F6> :let tmp=@f<CR>"fyaw<Esc>:bot split ~/.vimrc<CR>G?LAST_SPELL<CR>zRkoiab<Space><Esc>"fp<Esc>:let @f=tmp<CR>a<Space>

" Try to stop using the arrows, use hjkl instead
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>
vnoremap <up>    <nop>
vnoremap <down>  <nop>
vnoremap <left>  <nop>
vnoremap <right> <nop>

" I get capitalised commands all the time, will try to avoid it with this
" mapping.
nnoremap ; :

" Easily move through windows
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l


" Make shift insert work in the gui as it does in the shell.
if has('gui_running')
    silent noremap! <S-Insert> <MiddleMouse>
endif

" Diff operations made shorter (Great for merges)
if &diff
    nnoremap <Leader>du  :diffupdate<cr>
    nnoremap <Leader>dg  :diffget<cr>
    nnoremap <Leader>dp  :diffput<cr>
    nnoremap <Leader>dg1 :diffget 1<cr>
    nnoremap <Leader>dg2 :diffget 2<cr>
    nnoremap <Leader>dg3 :diffget 3<cr>
endif

" ----------------------------------------------------------------------------
" }}}
" {{{ Cscope
" ----------------------------------------------------------------------------

if has("cscope")
    if $CSCOPE_BIN != ""
        set csprg=$CSCOPE_BIN
    endif
    set csto=0
    " set cst  " Map all the tag lookups to cscope
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        if filereadable($CSCOPE_DB)
            cs add $CSCOPE_DB
        endif
    endif
    set csverb

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " displays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "


    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>


    " Using 'CTRL-spacebar' (interpreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
else
    echo "No cscope"
endif

" ----------------------------------------------------------------------------
" }}}
" {{{ Abbreviations
" ----------------------------------------------------------------------------

" {{{ Usual spelling mistakes
" ---------------------------
iab teh         the
iab becuase     because
iab defualt     default
iab Defualt     Default
iab whould      should
iab Whould      Should
" LAST_SPELL (this is a marker for quick search)
" ---------------------------
" }}}

" ----------------------------------------------------------------------------
" }}}
" {{{ Plugin configuration
" ----------------------------------------------------------------------------


" Tasklist: List of markers for tasks
let g:tlTokenList = ['\<TODO\>', '\<FIXME\>', '\<QUESTION\>', '\<HACK\>', '\<XXXJDV\>']

" NERDCommenter: Add a space after the comment symbol
let NERDSpaceDelims=1

" TagList: Generate tags even if the TList window is closed.
let Tlist_Process_File_Always = 1

" TagList: Display tags defined only in the current buffer.
let Tlist_Show_One_File = 1

" TagList: Close Vim if the taglist is the only window.
let Tlist_Exit_OnlyWindow = 1

" SqlCompletion: disable generated maps, they are annoying!
let g:omni_sql_no_default_maps = 1

" ShowMarks: Disable on startup (will use it on demand)
let g:showmarks_enable = 0

" Pylint: Disable calling pylint automatically when saving
let g:pylint_onwrite = 0
"
" Tagbar: show the tag corresponding to the current cursor position
let g:tagbar_autoshowtag = 1

" Tagbar: map <F9> to toggle tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

" VimNotes: Set notes dir in dropbox
if $DDROPBOX != "" && isdirectory($DDROPBOX)
    let g:notes_directory=$DDROPBOX . "/vimnotes"
    let g:notes_shadowdir=g:notes_directory . "/shadow"
endif

" Doxygen: Autoload doxygen highlighting
let g:load_doxygen_syntax = 1

" Snipmate: My name for Snippets
if $MYFULLNAME != ""
    let g:snips_author=$MYFULLNAME
endif

" ----------------------------------------------------------------------------
" }}}
" {{{ Local configuration

" Load local settings. The local settings file is untracked and it is the
" source of configuration settings that only make sense in some of the
" machines I use, e.g., I could have some extra settings for work machines or
" some overrides for remote headless boxes.
" This should also work on Windows, since ~.vim is added to the runtimepath at
" the top of this file.
" Warning: Additional Bundles should not be included in this file, use the
"          local/bundles.vim file instead.
if filereadable(expand('~/.vim/local/config.vim'))
    execute 'source ' . expand('~/.vim/local/config.vim')
endif

" }}}
" {{{ Experimental area
" ----------------------------------------------------------------------------

" The whole experimental area can be disabled by running vim as vine or gvine.
" (Create symbolic links or copy the executable file)
if v:progname != "vine" && v:progname != "gvine"

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
    autocmd FileType python compiler pylint

    " When opening a file, go to the last known position when the file was last
    " open.
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

augroup END

" Reload this configuration file automatically when it is changed within Vim
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc
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

endif
" ----------------------------------------------------------------------------
" }}}
" vim:fdm=marker:et:ts=4:
