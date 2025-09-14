#!/bin/bash
#############################################################################
#
# FILE:         040_misc_aliases.sh
#
# DESCRIPTION:  
#
#############################################################################


alias myalias='showaliases $DBASH/* $DBASH/local/after/* $DBASH/local/before/*'
alias rlsh='reloadsh'

alias vish='edot $DBASH'
alias vishaf='edot $DBASH/local/after'
alias gvish='gvim $DBASH'
alias vivi='vim $HOME/.vimrc'
alias gvivi='gvim $HOME/.vimrc'
alias vif='vim $(fzf -x)'

alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias '..?'='show_parent_dirs'
alias p=pwd

alias du1='du --max-depth 1'
alias dumd='du --max-depth'

alias clearcache='sudo sync; sudo echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null'

alias xff='export TERM=xterm-256color'

alias ip0='getip4 eth0'

alias ud='export DISPLAY=:0.0'

alias agi='sudo apt-get install'

alias l=ls
alias sl=ls
alias sls=ls

alias cp="rsync -avz"

alias git-root='cd "$(git rev-parse --show-toplevel)"'
alias g=git
alias tit=git

complete -o bashdefault -o default -o nospace -F _git g
complete -o bashdefault -o default -o nospace -F _git tit

alias workon='pew workon $(pew ls | mysplit | fzf)'

alias mc='TERM=xterm-256color mc'
alias mux=tmuxinator

if is_osx
then
   alias ls='ls -G'
else
   alias go=xdg-open  # Legacy: from when it was gnome-open, try to get used to xo
   alias xo=xdg-open
   alias start=xdg-open

   alias pbcopy='xsel --clipboard --input'
   alias pbpaste='xsel --clipboard --output'
fi

alias ag='ag --color-path="1;38;5;201" --color-line-number="1;38;5;81" --color-match="48;5;214;38;5;0"'

alias espanso-cfg='(cd "$(espanso path config)" && fzf --preview "EDITOR=less espanso edit '{}'" --bind "enter:execute(espanso edit '{}')")'

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
