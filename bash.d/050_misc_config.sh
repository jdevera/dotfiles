#!/bin/bash
#############################################################################
#
# FILE:         050_misc_config.sh
#
# DESCRIPTION:  
#
#############################################################################

# Section: Setting the right TERM value {{{
#############################################################################
if [[ -z $TMUX ]]; then
   case $COLORTERM in
      (Terminal|gnome-256color|xfce4-terminal)
         TERM=gnome-256color tput colors > /dev/null 2>&1  &&  export TERM='gnome-256color'
         ;;
   esac
fi

#############################################################################

# }}}
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
# Section: PATH {{{
#############################################################################

# Add my admin scripts to the path
pathprepend "$DADMIN/scripts"
pathprepend "$DOTHER/run/bin"

# Add user's Cabal binaries to the path
pathprepend "$HOME/.cabal/bin"

pathprepend "$HOME/.local/bin"


#############################################################################

# }}}
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
# Section: LESS {{{
#############################################################################

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# LESS colours for man pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
# export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_so=$'\E[1;37;7m'      # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#############################################################################

# }}}
# Section: Prompt {{{
#############################################################################

ansi_color()
{
   local color
   case "$1" in
      black)        color="\e[0;30m";;
      red)          color="\e[0;31m";;
      green)        color="\e[0;32m";;
      brown)        color="\e[0;33m";;
      blue)         color="\e[0;34m";;
      purple)       color="\e[0;35m";;
      cyan)         color="\e[0;36m";;
      light_gray)   color="\e[0;37m";;
      dark_gray)    color="\e[1;30m";;
      light_red)    color="\e[1;31m";;
      light_green)  color="\e[1;32m";;
      yellow)       color="\e[1;33m";;
      light_blue)   color="\e[1;34m";;
      light_purple) color="\e[1;35m";;
      light_cyan)   color="\e[1;36m";;
      white)        color="\e[1;37m";;
      none)         color="\e[0m";;
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
   BASH_THEME_CMD=theme_simple_prompt_cmd
}
# }}}

if [[ -z $KEEP_PROMPT ]]; then # KEEP_PROMPT=1 reloadsh will reload without affecting the prompt

PROMPT_SYMBOL=' ⇶ '
theme_simple

fi


function prompt_command()
{
   LAST_RC=$?
   if [[ -n $BASH_THEME_CMD ]]; then
      eval "$BASH_THEME_CMD"
   fi
   log_bash_persistent_history
}

export PROMPT_COMMAND=prompt_command


#############################################################################

# }}}
# Section: History {{{
#############################################################################

# HISTCONTROL {{{
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

# }}}
# HISTSIZE {{{
# ========
# The number of commands to remember in the command history. The default value
# is 500.
HISTSIZE=5000

# }}}
# HISTFILESIZE {{{
# ============
# The maximum number of lines contained in the history file. When this variable
# is assigned a value, the history file is truncated, if necessary, by removing
# the oldest entries, to contain no more than that number of  lines. The
# default value is 500. The history file is also truncated to this size after
# writing it when an interactive shell exits.
HISTFILESIZE=20000

# }}}
# HISTIGNORE {{{
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

# }}}
# HISTTIMEFORMAT {{{
# ==============
# If this variable is set and not null, its value is used as a format string
# for strftime(3) to print the time stamp associated with each history entry
# displayed by the history builtin.  If this variable is set, time stamps are
# written to the history file so they may be preserved across shell sessions.
# This uses the history comment character to distinguish timestamps from other
# history lines.
HISTTIMEFORMAT="%Y-%m-%d %T %z "

# }}}
# shopt: histappend {{{
# =================
# If set, the history list is appended to the file named by the value of the
# HISTFILE variable when the shell exits, rather than overwriting the file.
shopt -s histappend

# }}}
#############################################################################

# }}}
# Section: Bash Options {{{
#############################################################################
# checkwinsize {{{
# ------------
#
# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize

# }}}
# cdspell {{{
# -------
#
# If set, minor errors in the spelling of a directory component in a cd command
# will be corrected. The errors checked for are transposed characters, a
# missing character, and a character too many. If a correction is found, the
# corrected path is printed, and the command proceeds. This option is only used
# by interactive shells.
shopt -s cdspell

# }}}
# extglob {{{
# -------
#
# If set, several extended pattern matching operators are recognized:
#   ?(pattern-list) Matches zero or one occurrence of the given patterns
#   *(pattern-list) Matches zero or more occurrences of the given patterns
#   +(pattern-list) Matches one or more occurrences of the given patterns
#   @(pattern-list) Matches one of the given patterns
#   !(pattern-list) Matches anything except one of the given patterns
shopt -s extglob

# }}}
#############################################################################

# }}}

# Get my name from the system to make it easily available everywhere I might
# need it
export MYFULLNAME=$(getent passwd $(whoami) | cut -d ':' -f 5 | cut -d ',' -f 1)


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

