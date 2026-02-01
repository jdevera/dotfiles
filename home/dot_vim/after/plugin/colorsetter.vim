" Name:         Colorscheme setter
" Author:       Jacobo de Vera
" Base:         Tip 1619
"
" -----------------------------------------------------------------------------
"
" Description:  Sets the colorscheme based on environment.
"
" The preferred colorschemes can be specified in the .vimrc file with the
" global variables:
"
"   * g:my_gui_colorscheme for the colorscheme to load if Vim is running with
"   a GUI or if termguicolors is enabled (true color terminal).
"
"   * g:my_terminal_colorscheme for the colorscheme to load if Vim is running
"   on a terminal without true color support.
"
" -----------------------------------------------------------------------------


" Set defaults for colorschemes
" -----------------------------------------------------------------------------
if !exists('g:my_gui_colorscheme')
    let g:my_gui_colorscheme = 'desert'
endif

if !exists('g:my_terminal_colorscheme')
    let g:my_terminal_colorscheme = 'default'
endif

if !exists('g:my_gui_diff_colorscheme')
   let g:my_gui_diff_colorscheme = g:my_gui_colorscheme
endif

if !exists('g:my_terminal_diff_colorscheme')
   let g:my_terminal_diff_colorscheme = g:my_gui_colorscheme
endif
" -----------------------------------------------------------------------------

if has("gui_running") || &termguicolors
    " GUI or true color terminal - use rich colorscheme
    if &diff
       exe 'colorscheme' g:my_gui_diff_colorscheme
    else
       exe 'colorscheme' g:my_gui_colorscheme
    endif
else
    " Limited color terminal - use simpler colorscheme
    if &diff
       exe 'colorscheme' g:my_terminal_diff_colorscheme
    else
       exe 'colorscheme' g:my_terminal_colorscheme
    endif
    set background=dark
endif
