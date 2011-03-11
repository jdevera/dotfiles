#!/bin/bash
#############################################################################
#
# FILE:         040_misc_aliases.sh
#
# DESCRIPTION:  
#
#############################################################################


alias vish='vim $DBASH'
alias gvish='gvim $DBASH'
alias reloadsh='source $HOME/.bashrc'

alias myalias='showaliases $DBASH/* $DBASH/local/after/* $DBASH/local/before/*'

alias vivi='vim $HOME/.vimrc'
alias gvivi='gvim $HOME/.vimrc'

alias viil='vim $DSYSDATA/install.log -c "\$"'
alias gviil='gvim $DSYSDATA/install.log -c "\$"'

alias mountbooks='truecrypt -t -k "" --protect-hidden=no /media/PLATYPUS/c/secure.tc $DOTHER/books/'

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..?='show_parent_dirs'

alias du1='du --max-depth 1'
alias dumd='du --max-depth'



# vim: ft=bash fdm=marker expandtab ts=3 sw=3 :

