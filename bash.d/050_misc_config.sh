#!/bin/bash
#############################################################################
#
# FILE:         050_misc_config.sh
#
# DESCRIPTION:  
#
#############################################################################


# Section: Files and directories (ENV) {{{
#############################################################################

# Directories
export DDOC=$HOME/doc
export DMEDIA=$HOME/media
export DBACKUP=$HOME/backup
export DDOWN=$HOME/comms/downloads
export DOTHER=$HOME/other
export DADMIN=$DOTHER/admin
export DSYSDATA=$DADMIN/data
export DDROPBOX=$HOME/comms/Dropbox
export DBASH=$HOME/.bash.d
export DDESKTOP=$DOTHER/Desktop
export DAPTCACHE=/var/cache/apt/archives

# Files
export FSYSLOG=/var/log/syslog
export FILOG=$DSYSDATA/install.log


#############################################################################
# }}}

if [[ -z $TMUX ]]; then
   case $COLORTERM in
      (Terminal|gnome-256color|xfce4-terminal)
         TERM=gnome-256color tput colors > /dev/null 2>&1  &&  export TERM='gnome-256color'
         ;;
   esac
fi

# Add my admin scripts to the path
pathprepend "$DADMIN/scripts"
pathprepend "$DOTHER/run/bin"

# Add user's Cabal binaries to the path
pathprepend "$HOME/.cabal/bin/"

pathprepend "$DDROPBOX/todo"


# Section: Apps {{{
#############################################################################

export DIFF=vimdiff
export EDITOR=vim

if which vimpager > /dev/null 2>&1; then
   export PAGER=vimpager
elif which most > /dev/null 2>&1; then
   export PAGER=most
else
   export PAGER='less -R'
fi

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Use a python init file
[[ -e ~/.pystartup ]] && export PYTHONSTARTUP=~/.pystartup

#############################################################################
# }}}   

# Section: Prompt {{{
#############################################################################

ansi_color()
{
   local COLOR_BLACK="\033[0;30m"
   local COLOR_RED="\033[0;31m"
   local COLOR_GREEN="\033[0;32m"
   local COLOR_BROWN="\033[0;33m"
   local COLOR_BLUE="\033[0;34m"
   local COLOR_PURPLE="\033[0;35m"
   local COLOR_CYAN="\033[0;36m"
   local COLOR_LIGHT_GRAY="\033[0;37m"
   local COLOR_DARK_GRAY="\033[1;30m"
   local COLOR_LIGHT_RED="\033[1;31m"
   local COLOR_LIGHT_GREEN="\033[1;32m"
   local COLOR_YELLOW="\033[1;33m"
   local COLOR_LIGHT_BLUE="\033[1;34m"
   local COLOR_LIGHT_PURPLE="\033[1;35m"
   local COLOR_LIGHT_CYAN="\033[1;36m"
   local COLOR_WHITE="\033[1;37m"
   local COLOR_NONE="\033[m"
   local color=$COLOR_NONE
   case "$1" in
      black)        color=$COLOR_BLACK;;
      red)          color=$COLOR_RED;;
      green)        color=$COLOR_GREEN;;
      brown)        color=$COLOR_BROWN;;
      blue)         color=$COLOR_BLUE;;
      purple)       color=$COLOR_PURPLE;;
      cyan)         color=$COLOR_CYAN;;
      light_gray)   color=$COLOR_LIGHT_GRAY;;
      dark_gray)    color=$COLOR_DARK_GRAY;;
      light_red)    color=$COLOR_LIGHT_RED;;
      light_green)  color=$COLOR_LIGHT_GREEN;;
      yellow)       color=$COLOR_YELLOW;;
      light_blue)   color=$COLOR_LIGHT_BLUE;;
      light_purple) color=$COLOR_LIGHT_PURPLE;;
      light_cyan)   color=$COLOR_LIGHT_CYAN;;
      white)        color=$COLOR_WHITE;;
      none)         color=$COLOR_NONE;;
   esac
   echo "$color"
}

ansi_color256()
{
   echo "\033[38;5;$1m"
}

#THEMES

# THEME: simple prompt {{{
function theme_simple_prompt_cmd()
{
   local rc=$?
   local prompt_symbol=${PROMPT_SYMBOL:-"$ "}
   local color=yellow
   [[ $rc -ne 0 ]] && color=light_red
   PS1="\[$(ansi_color $color)\]$prompt_symbol\[$(ansi_color none)\] "
}

theme_simple()
{
   export PROMPT_COMMAND=theme_simple_prompt_cmd
}
# }}}

if [[ -z $KEEP_PROMPT ]]; then # KEEP_PROMPT=1 reloadsh will reload without affecting the prompt

PROMPT_SYMBOL=' ⇶ '
theme_simple

fi

#############################################################################
# }}}

# Section: History {{{
#############################################################################

# HISTCONTROL
# ===========
# A colon-separated list of values controlling how commands are saved on the
# history list. If the list of values includes ignorespace, lines which begin
# with a space character are not saved in the history list. A value of
# ignoredups causes lines matching the previous history entry to not be saved.
# A value of ignoreboth is shorthand for ignorespace and ignoredups. A value of
# erasedups causes all previous lines matching the current line to be removed
# from the history list before that line is saved. Any value not in the above
# list is ignored. If HISTCONTROL is unset, or does not include a valid value,
# all lines read by the shell parser are saved on the history list, subject to
# the value of HISTIGNORE. The second and subsequent lines of a multi-line
# compound command are not tested, and are added to the history regardless of
# the value of HISTCONTROL.
HISTCONTROL=ignorespace

# HISTSIZE
# ========
# The number of commands to remember in the command history. The default value
# is 500.
HISTSIZE=2000

# HISTFILESIZE
# ============
# The maximum number of lines contained in the history file. When this variable
# is assigned a value, the history file is truncated, if necessary, by removing
# the oldest entries, to contain no more than that number of  lines. The
# default value is 500. The history file is also truncated to this size after
# writing it when an interactive shell exits.
HISTFILESIZE=10000

# HISTIGNORE
# ==========
# A colon-separated list of patterns used to decide which command lines should
# be saved on the history list. Each pattern is anchored at the beginning of
# the line and must match the complete line (no implicit `*' is appended). Each
# pattern is tested against the line after the checks specified by HISTCONTROL
# are applied. In addition to the normal shell pattern matching characters, `&'
# matches the previous history line. `&' may be escaped using a backslash; the
# backslash is removed before attempting a match. The second and subsequent
# lines of a multi-line compound command are not tested, and are added to the
# history regardless of the value of HISTIGNORE.
HISTIGNORE="ls:cd:cd *:pwd:cdd *:p"

# shopt: histappend
# =================
# If set, the history list is appended to the file named by the value of the
# HISTFILE variable when the shell exits, rather than overwriting the file.
shopt -s histappend


#############################################################################
# }}}   

# Get my name from the system to make it easily available everywhere I might
# need it
export MYFULLNAME=$(getent passwd $(whoami) | cut -d ':' -f 5 | cut -d ',' -f 1)

# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize


# cdspell
# -------
#
# If set, minor errors in the spelling of a directory component in a cd command
# will be corrected. The errors checked for are transposed characters, a
# missing character, and a character too many. If a correction is found, the
# corrected path is printed, and the command proceeds. This option is only used
# by interactive shells.
shopt -s cdspell

# extglob
# -------
#
# If set, several extended pattern matching operators are recognized:
#   ?(pattern-list) Matches zero or one occurrence of the given patterns
#   *(pattern-list) Matches zero or more occurrences of the given patterns
#   +(pattern-list) Matches one or more occurrences of the given patterns
#   @(pattern-list) Matches one of the given patterns
#   !(pattern-list) Matches anything except one of the given patterns
shopt -s extglob

# CTRL-D must be used twice to exit the shell
export IGNOREEOF=1

# Enable programmable completion features asynchronously
# See http://superuser.com/a/418112 for details
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
   trap 'source /etc/bash_completion ; trap USR1' USR1
   { sleep 0.1 ; builtin kill -USR1 $$ ; } & disown
fi


if [[ -z $TMUX ]]; then
   call_if check_home_purity
fi

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

