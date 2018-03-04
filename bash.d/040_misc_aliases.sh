#!/bin/bash
#############################################################################
#
# FILE:         040_misc_aliases.sh
#
# DESCRIPTION:  
#
#############################################################################


alias vish='vim $DBASH'
alias vishaf='vim $DBASH/local/after'
alias gvish='gvim $DBASH'
alias rlsh='reloadsh'

alias myalias='showaliases $DBASH/* $DBASH/local/after/* $DBASH/local/before/*'

alias vivi='vim $HOME/.vimrc'
alias gvivi='gvim $HOME/.vimrc'

alias viil='vim $DSYSDATA/install.log -c "\$"'
alias gviil='gvim $DSYSDATA/install.log -c "\$"'

alias vif='vim $(fzf -x)'

alias mountbooks='truecrypt -t -k "" --protect-hidden=no /media/PLATYPUS/c/secure.tc $DOTHER/books/'

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..?='show_parent_dirs'
alias p=pwd

alias du1='du --max-depth 1'
alias dumd='du --max-depth'

alias clearcache='sudo sync; sudo echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null'

alias xff='export TERM=xterm-256color'

alias ip0='getip4 eth0'

alias ud='export DISPLAY=:0.0'

alias agi='sudo apt-get install'
make_completion_wrapper _apt_get __complete_agi agi apt-get install
complete -F __complete_agi agi

alias l=ls
alias sl=ls
alias sls=ls

alias kb='emacs $DDOC/PKB/notes.org'

alias cp="rsync -avz"

alias git-root='cd "$(git rev-parse --show-toplevel)"'
alias g=git
alias tit=git

complete -o bashdefault -o default -o nospace -F _git g
complete -o bashdefault -o default -o nospace -F _git tit

alias jo=jrnl
alias jot='jrnl --export text | less -RMSFiX'

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'


alias workon='pew workon $(pew ls | mysplit | fzf)'

alias mc='TERM=xterm-256color mc'
alias mux=tmuxinator
alias syslog='grc tail -F /var/log/syslog'
alias ifconfig='grc ifconfig'

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
