" ---------------------------------------------------------------------------
"                           VIM configuration file
" ---------------------------------------------------------------------------
" Author: Jacobo de Vera
" Repo:   https://github.com/jdevera/dotfiles
" ---------------------------------------------------------------------------

" {{{ Start declaring the encoding of this very file
scriptencoding utf-8
set encoding=utf-8

" }}}
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
" {{{ Plugins configuration (must precede others)

call plug#begin('~/.vim/bundle')

" ===========================================================================
" Plugins
" ===========================================================================

Plug 'jdevera/vim-snippets', {'frozen': 1}
Plug 'SirVer/ultisnips'

" Surround and repeat (to make the former repeatable)
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Interface
Plug 'godlygeek/csapprox'
Plug 'majutsushi/tagbar', { 'on' : 'TagbarToggle' }
Plug 'bootleq/ShowMarks', { 'on' : 'ShowMarksToggle' } " Show vim marks in the gutter
Plug 'vim-scripts/bufexplorer.zip', { 'on' : ['BufExplorer', 'BufExplorerHorizontalSplit', 'BufExplorerVerticalSplit' ] }
Plug 'techlivezheng/vim-plugin-minibufexpl' " A small window with a list of buffers that appears on top after a number of buffers are open
Plug 'scrooloose/nerdtree'
Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }  " Undo tree visualization
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim', {'on': 'Goyo' } " Distraction-free writing


Plug 'AndrewRadev/linediff.vim', {'on': 'Linediff'}  " Diff two separate blocks of text
Plug 'AndrewRadev/switch.vim', { 'on': ['Switch', 'SwitchReverse'], 'for': ['gitrebase', 'python'] }  " Switch between words in a group
Plug 'Valloric/YouCompleteMe'
Plug 'benjifisher/matchit.zip' " Make % jump to matching pairs that are language aware
Plug 'chaoren/vim-wordmotion'  " Jump words in camelCase or snake_case
Plug 'chrisbra/vim-diff-enhanced' " Apply a different slow diff algorithm to vimdiff
Plug 'davidhalter/jedi-vim'
Plug 'embear/vim-foldsearch', { 'on': ['Fw', 'Fs', 'Fp', 'FS', 'Fl', 'Fc', 'Fi', 'Fd', 'Fe']}  " Search, and fold all lines without matches
Plug 'gilsondev/searchtasks.vim', { 'on' : ['SearchTags', 'SearchTagsGrep'] }
Plug 'godlygeek/tabular' " Simple text alignment
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': {-> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'luochen1990/rainbow'  " Rainbow parentheses
Plug 'rhysd/conflict-marker.vim' " Navigate through merge conflicts and choose which to choose
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-abolish' " Search and replace several variations of a word with the S command
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'dense-analysis/ale'


" Python
Plug 'vim-python/python-syntax', {'for' : 'python' }
Plug 'tmhedberg/SimpylFold', {'for' : 'python' } " Correct folding for python
Plug 'jeetsukumaran/vim-pythonsense', {'for' : 'python' } " Text Objects for python programs
Plug 'jmcantrell/vim-virtualenv'


" File types support
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'asciidoc/vim-asciidoc'      " Syntax for ASCII doc
Plug 'cespare/vim-toml'
Plug 'ekalinin/Dockerfile.vim'    " Syntax for Dockerfiles
Plug 'elzr/vim-json', { 'for' : 'json' } " This makes JSON more readable
Plug 'mustache/vim-mustache-handlebars' " Mustache templates syntax and abbreviations
Plug 'pearofducks/ansible-vim'
Plug 'plasticboy/vim-markdown'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'vim-scripts/Better-CSS-Syntax-for-Vim', { 'for' : ['css', 'html'] }


" My own plugins / forks
Plug 'jdevera/vim-bashmarks-syntax', {'for': 'bashmarks'}
Plug 'jdevera/vim-cs-explorer'
Plug 'jdevera/vim-protobuf-syntax'


" Colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'flazz/vim-colorschemes'
Plug 'morhetz/gruvbox'
Plug 'obxhdx/vim-github-theme'
Plug 'tomasr/molokai'
Plug 'vim-scripts/Colorzone'
Plug 'vim-scripts/DarkOcean.vim'
Plug 'vim-scripts/Mustang2'
Plug 'vim-scripts/asu1dark.vim'
Plug 'vim-scripts/lightcolors'
Plug 'vim-scripts/print_bw.zip'
Plug 'joshdick/onedark.vim'


" Load additional local plugins. The local/bundles.vim file, if it
" exists, contains Plugin specs that make sense only in the current
" machine. That file is not tracked. See also the *Local configurations*
" section below.
if filereadable(expand('~/.vim/local/bundles.vim'))
    execute 'source ' . expand('~/.vim/local/bundles.vim')
endif

call plug#end()

" }}}
" {{{ Behaviour?
" ----------------------------------------------------------------------------

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

" New windows (vsplit) on the right of the current one
set splitright

" New windows (split) below the current one
set splitbelow

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=4

" Enable persistent undo
set undofile

" List of directory names for undo files, separated with commas. At least one
" must exist or vim will silently not use persistent undo
set undodir=~/.vim/tmp/undodir

" Maximum number of changes that can be undone
set undolevels=1000

" Save the whole buffer for undo when reloading it if it has less than 10K
" lines
set undoreload=10000

" Do not wrap around when doing searches
set nowrapscan

" put swap files in the same directory
set directory^=~/.vim/tmp/swap

" Do not write backup files
set nobackup


" When opening a file, go to the last known position when the file was last
" open.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Consider all my additional gitconfig files as such
au BufNewFile,BufRead gitconfig* set filetype=gitconfig


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
set listchars=tab:»»,trail:·,eol:↵

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
elseif has('osx')
    set macligatures
    set guifont=Fira\ Code:h16
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
    set t_AB=^[[48;5;%dm
    set t_AF=^[[38;5;%dm
endif


" Set a nice colorscheme for GUI and terminal.
" -----------------------------------------------
" Note: These colours are set in an after plug-in called colorschemesetter
let g:my_gui_colorscheme = 'molokai'
let g:my_terminal_colorscheme = 'torte'
let g:my_gui_diff_colorscheme = 'github'
let g:my_terminal_diff_colorscheme = 'github'
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
" highlight rightMargin term=bold ctermfg=red guifg=red guibg=yellow
" match rightMargin /\%<122v.\%>121v/ " Only the 120th char
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
    let g:virtualenv_stl_format = '[venv:%n]'
    function! Status_fugitive()
        return exists('*fugitive#statusline') ?
                 \ fugitive#statusline() :
                 \ ''
    endfunction
    function! Status_virtualenv()
        return exists('*virtualenv#statusline') ?
                    \ virtualenv#statusline() :
                    \ ''
    endfunction
    set statusline=%F%m%r%h%w\ %{Status_fugitive()}%y\ %{Status_virtualenv()}\ ff:%{(&ff[0])}\ c:%v\ l:%l\ (%p%%\ of\ %L)
endif
" -----------------------------------------------


" ----------------------------------------------------------------------------
" }}}
" {{{ Key mapping
" ----------------------------------------------------------------------------

" Set , as the map leader (The default \ is hard to type in Spanish keyboards)
let mapleader = ","

" F5 toggles the QickFix window
silent nnoremap <F5> :botright cwindow<CR>

" <F4> toggles the directory listing window
silent nnoremap <F4> :NERDTreeToggle<CR>

" ,gut Toggles Mundo
silent noremap <Leader>gut :MundoToggle<CR>

" ,t runs ToggleWord
silent noremap <Leader>t :ToggleWord<CR>

" ,tl for task list
silent noremap <leader>#tl <Plug>TaskList
silent noremap <leader>tl :TaskList<CR>


" ,ag uses Ag to search the word under the cursor
silent noremap <Leader>ag :exec 'Ag '.expand("<cword>")<CR>

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

" I get capitalised commands all the time, will try to avoid it with this
" mapping.
nnoremap ; :

" Make shift insert work in the gui as it does in the shell.
if has('gui_running')
    silent noremap! <S-Insert> <MiddleMouse>
endif

" Diff operations made shorter (Great for merges)
function! SetDiffMappings()
    nnoremap <Leader>du  :diffupdate<cr>
    nnoremap <Leader>dg  :diffget<cr>
    nnoremap <Leader>dp  :diffput<cr>
    nnoremap <Leader>dg1 :diffget 1<cr>
    nnoremap <Leader>dg2 :diffget 2<cr>
    nnoremap <Leader>dg3 :diffget 3<cr>
endfunction
if &diff
    call SetDiffMappings()
endif


" A quick way to build whatever
nnoremap <C-F9> :make<CR>

" ----------------------------------------------------------------------------
" }}}
" {{{ Language (spelling)
" ----------------------------------------------------------------------------

" USe the current system list of words as dictionary for completion with
" C-X C-K  ( :he i_CTRL-X_CTRL-K )
if filereadable("/usr/share/dict/words")
    set dictionary+=/usr/share/dict/words
endif

" Set British English as the language for spelling corrections
set spelllang=en_gb


" {{{ Usual spelling mistakes
" ---------------------------
iab teh         the
iab becuase     because
iab defualt     default
iab Defualt     Default
iab whould      should
iab Whould      Should
iab summaires   summaries
iab redered     rendered

" LAST_SPELL (this is a marker for quick search)
" ---------------------------
" }}}

" ----------------------------------------------------------------------------
" }}}
" {{{ Plugin configuration
" ----------------------------------------------------------------------------

" ALE Python: Use flake8 and pylint as linters for Python files
let g:ale_linters = { 'python': ['flake8', 'pylint'] }

" ALE Python: Tell MyPy not to check for syntax
" When set to `1`, syntax error messages for mypy will be ignored. This option
" can be used when running other Python linters which check for syntax errors,
" as mypy can take a while to finish executing.
let g:ale_python_mypy_ignore_invalid_syntax = 1

" Ack_vim: Redefine all Ack commands as Ag:
for command in ['Ack', 'AckAdd', 'AckFromSearch', 'LAck', 'LAckAdd', 'AckFile', 'AckHelp', 'LAckHelp', 'AckWindow', 'LAckWindow']
    execute 'command! -bang -nargs=* ' . substitute(command, 'Ack', 'Ag', '') . ' ' . command . '<bang> <args>'
endfor

" Ack_vim: Use Ag
let g:ackprg = 'ag --vimgrep'

" Fzfvim: Set up command prefix
let g:fzf_command_prefix = 'F'

" SympylFold: Show docstring preview in python folds
let g:SimpylFold_docstring_preview = 1

" Switch: Toggle words
autocmd FileType gitrebase let b:switch_custom_definitions =
    \ [
    \   [ 'pick', 'reword', 'edit', 'squash', 'fixup', 'exec' ],
    \ ]

autocmd FileType python let b:switch_custom_definitions =
    \ [
    \   ['True', 'False'],
    \   ['return', 'yield'],
    \ ]

" Wordmotion: Use only when moving with Leader key
let g:wordmotion_prefix = '<Leader>'

" Virtualenv: Attempt to detect virtual env and activate it
let g:virtualenv_auto_activate = 1

" NERDCommenter: Add a space after the comment symbol
let NERDSpaceDelims=1

" SqlCompletion: disable generated maps, they are annoying!
let g:omni_sql_no_default_maps = 1

" ShowMarks: Disable on startup (will use it on demand)
let g:showmarks_enable = 0

"
" Tagbar: show the tag corresponding to the current cursor position
let g:tagbar_autoshowtag = 1

" Tagbar: map <F9> to toggle tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

" Snipmate: My name for Snippets
if $MYFULLNAME != ""
    let g:snips_author=$MYFULLNAME
endif

" XML: Enable folding based on syntax
let g:xml_syntax_folding = 1

" PythonSyntax: Highlight everything
let g:python_highlight_all=1
let g:python_slow_sync=1

" Sh: Assume sh is bash
let g:is_bash = 1

" Syntastic: Set per-language checkers
let g:syntastic_python_checkers = ['flake8', 'pylint', 'python']
let g:syntastic_python_pylint_rcfile = '$HOME/.pylintrc'
let g:syntastic_python_pylint_post_args = "--max-line-length=120"
let g:syntastic_python_flake8_post_args = "--ignore=E501"
let g:syntastic_python_python_use_codec = 1

" Syntastic: Set behaviour
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_error_symbol = "\u2717"
let g:syntastic_warning_symbol = "\u26A0"
let g:syntastic_always_populate_loc_list = 1
" When set to 3 the error window will be automatically opened when errors are
" detected, but not closed automatically.
let g:syntastic_auto_loc_list = 3

" Tagbar: Additional language support:
"
" Support for reStructuredText, if available.
" https://github.com/jszakmeister/rst2ctags
if executable("rst2ctags")
    " tagbar settings
    let g:tagbar_type_rst = {
        \    'ctagstype': 'rst',
        \    'ctagsbin' : 'rst2ctags',
        \    'ctagsargs' : '-f - --sort=yes',
        \    'kinds' : [
        \        's:sections',
        \        'i:images'
        \    ],
        \    'sro' : '|',
        \    'kind2scope' : {
        \        's' : 'section',
        \    },
        \    'sort': 0,
        \}
endif

" Support for Markdown, if available.
" https://github.com/jszakmeister/markdown2ctags
if executable("markdown2ctags")
   let g:tagbar_type_markdown = {
        \    'ctagstype': 'markdown',
        \    'ctagsbin' : 'markdown2ctags',
        \    'ctagsargs' : '-f - --sort=yes',
        \    'kinds' : [
        \        's:sections',
        \        'i:images'
        \    ],
        \    'sro' : '|',
        \    'kind2scope' : {
        \        's' : 'section',
        \    },
        \    'sort': 0,
        \}
endif

" Rainbow: Activate
let g:rainbow_active = 1

" UltiSnips: Set keys
let g:UltiSnipsExpandTrigger="<C-Y>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Jedi: Disable features that clash with YoutCompleteMe
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = "1"


" YouCompleteMe:
" When the following options is on, YCM aggressively empties the sign column
let g:ycm_enable_diagnostic_signs = 0
" Program name to search for python in the PATH
let g:ycm_python_binary_path = 'python3'

" VirtualEnv:
let g:virtualenv_directory = '$HOME/.local/share/virtualenvs/'
let g:virtualenv_auto_activate = 1

" MiniBufExplorer:
" Put new window above current or on the left for vertical split:
let g:miniBufExplBRSplit = 0
" Require at least 5 buffers before opening the BufExpl window
let g:miniBufExplBuffersNeeded = 5
" Don't open when running vimdiff or starting with -d
let g:miniBufExplHideWhenDiff = 1

" VimPlug: Timeout
let g:plug_timeout = 1000

" Mustache: Load abreviations to complete code
let g:mustache_abbreviations = 1

" ----------------------------------------------------------------------------
" }}}
" {{{ Local configuration

" Load local settings. The local settings file is untracked and it is the
" source of configuration settings that only make sense in some of the
" machines I use, e.g., I could have some extra settings for work machines or
" some overrides for remote headless boxes.
" This should also work on Windows, since ~.vim is added to the runtimepath at
" the top of this file.
" Warning: Additional plugins should not be included in this file, use the
"          local/bundles.vim file instead.
if filereadable(expand('~/.vim/local/config.vim'))
    execute 'source ' . expand('~/.vim/local/config.vim')
endif

" }}}
" {{{ Config reload support
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

" }}}
" {{{ Experimental area
" ----------------------------------------------------------------------------

" The whole experimental area can be disabled by running vim as vine or gvine.
" (Create symbolic links or copy the executable file)
if v:progname != "vine" && v:progname != "gvine"

   if filereadable(expand('~/.vim/experiments.vim'))
       execute 'source ' . expand('~/.vim/experiments.vim')
   endif

endif
" ----------------------------------------------------------------------------
" }}}
" vim:fdm=marker:et:ts=4:
