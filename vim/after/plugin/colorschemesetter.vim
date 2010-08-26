" Name:         Colorscheme setter
" Author:       Jacobo de Vera
" Base:         Tip 1619
"
" -----------------------------------------------------------------------------
"
" Description:  The setting of the colorscheme needs to be in an after plug-in
" so that the CSApprox plug-in, if present, has already been loaded when we
" get to this point.
"
" The preferred colorschemes can be specified in the .vimrc file with the
" global variables:

"   * g:my_gui_colorscheme for the colorscheme to load if Vim is running with
"   a GUI or if CSApprox is installed and the terminal supports more 88 colours
"   or more.

"   * g:my_terminal_colorscheme for the colorscheme to load if Vim is running
"   on a terminal and there is no support for enough colours.
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
" -----------------------------------------------------------------------------
    

if has("gui_running") || 
    \ (&t_Co >= 88 && exists('g:CSApprox_loaded'))
    " Even when Vim is running on a terminal, GUI colorschemes might still
    " look good if the terminal supports enough colours and the CSApprox
    " plug-in is installed.
    exe 'colorscheme' g:my_gui_colorscheme
else
    " Set a colour scheme suitable for dark backgrounds
    " since my terminals always have dark backgrounds.
    exe 'colorscheme' g:my_terminal_colorscheme
    set background=dark
endif
