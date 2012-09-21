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
alias reloadsh='KEEP_PROMPT=1 source $HOME/.bashrc'
alias rlsh='reloadsh'

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

alias clearcache='sudo sync; sudo echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null'

alias xff='export TERM=xterm-256color'

alias ip0='getip4 eth0'

alias ud='export DISPLAY=:0.0'

alias agi='sudo apt-get install'

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

