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
      (Terminal|gnome-terminal|gnome-256color|xfce4-terminal)
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

export PROJECT_HOME=$HOME/devel/myforge/projects

# Some MacOS overrides
if is_osx
then
   export DDOWN=$HOME/Downloads
   export PROJECT_HOME=$HOME/devel/projects
fi

# Files
export FSYSLOG=/var/log/syslog
export FILOG=$DSYSDATA/install.log

export NPM_PACKAGES="$HOME/.npm-packages"

#############################################################################

# }}}
# Section: PATH {{{
#############################################################################

# Add my admin scripts to the path
[[ -n $DADMIN ]] && pathprepend "$DADMIN/scripts"
[[ -n $DOTHER ]] && pathprepend "$DOTHER/run/bin"

pathprepend /usr/local/sbin

# Add user's Cabal binaries to the path
pathprepend "$HOME/.cabal/bin"

pathprepend "$HOME/.local/bin"
pathprepend "$HOME/.gem/ruby/1.9.1/bin"
pathprepend "$HOME/.gem/ruby/2.3.0/bin"
pathprepend "$HOME/.cargo/bin"

[[ -n $NPM_PACKAGES ]] && pathprepend "$NPM_PACKAGES/bin"

if has_command brew
then
   MANPATH="$(brew --prefix)/share/man:$MANPATH"
   INFOPATH="$(brew --prefix)/share/info:$INFOPATH"
   export MANPATH INFOPATH
fi


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
    if [[ -r ~/.dircolor ]]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Tell node js about the "global" package repo
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"


# Pyenv
if has_command pyenv
then
   export PYENV_ROOT="$HOME/.pyenv"
   eval "$(pyenv init -)"
fi


# Style for hless and hl, my wrappers around pygmentize
# Get all styles with: pygmentize -L styles
export HL_STYLE=one-dark


# Colours for ls on MacOS
if is_osx
then
   # Use colours in ls output
   export CLICOLOR=1
   # And make them look like linux
   export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
fi


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

function colorise() {
    local OFF="\e[0m"
    local color=$1
    shift
    echo "$(ansi_color "$color")$*$OFF"
}

function ansi_effect() {
    local effect
    case "$1" in
    bold) effect="\e[1m" ;;
    italic) effect="\e[3m" ;;
    underline) effect="\e[4m" ;;
    strikethrough) effect="\e[9m" ;;
    none) effect="\e[0m" ;;
    esac
    echo "$effect"
}

function effected() {

    local OFF="\e[0m"
    local effect=$1
    shift
    echo "$(ansi_effect "$effect")$*$OFF"
}

#THEMES

# THEME: simple prompt {{{
function theme_simple_prompt_cmd()
{
   local rc=${LAST_RC:-$?}
   local prompt_symbol=${PROMPT_SYMBOL:-"$ "}
   local color=yellow
   [[ $rc -ne 0 ]] && color=light_red
   PS1="\[$(ansi_color $color)\]$prompt_symbol\[$(ansi_color none)\] "
   if [[ -e $VIRTUAL_ENV ]]
   then
      local venvname
      venvname="$(basename "$VIRTUAL_ENV")"
      PS1="{venv:\[$(ansi_color white)\]$venvname\[$(ansi_color none)\]}$PS1"
   fi
}

theme_simple()
{
   # shellcheck disable=SC2034
   BASH_THEME_CMD=theme_simple_prompt_cmd
}
# }}}

if [[ -z $KEEP_PROMPT ]]; then # KEEP_PROMPT=1 reloadsh will reload without affecting the prompt

PROMPT_SYMBOL=' ⇶ '
theme_simple

fi


function precmd_rich_history()
{
   # Introduction {{{
   # -------------------------------------------------------------------------
   # I want to capture the return code of the program that run, and also the
   # PIPESTATUS value.
   #
   # This is a race, since anything that gets added to PROMPT_COMMAND before
   # this function will mean the values that are captured here correspond to
   # that function rather than the user command.
   #
   # Known modifiers of the return code
   # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   #
   # Starship
   # ==========
   #
   # A prompt manager, installs a handler precisely to capture the status of
   # the last run command.
   # It stores those values in the STARSHIP_CMD_STATUS and STARSHIP_PIPE_STATUS
   # variables.
   # It uses Bash-Preexec if present.
   #
   # Bash-Preexec
   # ============
   #
   # A Bash library that provides `preexec` and `precmd` hooks functions for
   # Bash 3.1+ in the style of Zsh.
   #
   # It captures both the resturn code and the PIPESTATUS, respectively, in the
   # __bp_last_ret_value and BP_PIPESTATUS variables.
   #
   # Site: https://github.com/rcaloras/bash-preexec
   #
   # Prep
   # -------------------------------------------------------------------------
   # As the first command, capture all status info from the previous command IN
   # ONE GO. If done in two separate assignments, the status of the first
   # assignment, and not that of the previous shell command, will be used
   # instead.
   local last_rc=$? last_pipestatus=("${PIPESTATUS[@]}")

   LAST_RC=
   LAST_PIPESTATUS=

   # If using starship to handle the prompt, then it already captured the
   # status info in its own variables. Use them here if available, as starship
   # runs its own prompt command first and the statuses captured above would
   # correspond to starship handling and not the command executed by the user.
   [[ -n $STARSHIP_CMD_STATUS ]]  && LAST_RC=$STARSHIP_CMD_STATUS
   [[ -n $STARSHIP_PIPE_STATUS ]] && LAST_PIPESTATUS=("${STARSHIP_PIPE_STATUS[@]}")

   # If using bash-preexec, save from them.
   [[ -n $__bp_last_ret_value ]] && LAST_RC=$__bp_last_ret_value
   [[ -n $BP_PIPESTATUS ]] && LAST_PIPESTATUS=("${BP_PIPESTATUS[@]}");

   # Otherwise, use the return codes captured at the start of this function.
   [[ -z $LAST_RC ]] && LAST_RC=$last_rc
   [[ -z $LAST_PIPESTATUS ]] && LAST_PIPESTATUS=("${last_pipestatus[@]}")


   # ----------------------------------------------------------------------}}}
   # Log rich history
   log_bash_persistent_history

}

function precmd_bash_theme()
{
   # Load the prompt theme if Starship is not running
   if [[ -z $STARSHIP_CMD_STATUS && -n $bash_theme_cmd ]]; then
      eval "$bash_theme_cmd"
   fi

}

if has_command starship
then
   eval -- "$(starship init bash --print-full-init)"
else
   echo "No starship, this is the path: $PATH"
fi

precmd_functions+=(precmd_rich_history)
precmd_functions+=(precmd_bash_theme)


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
HISTIGNORE="cd:cd *:cdd *:"

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
# Section: Bash Completion Options {{{
#############################################################################
# Cycle through available completions with Tab when there is more than one
bind 'TAB:menu-complete'

# Cycle in reverse with Shift-Tab
bind '"\e[Z": menu-complete-backward'

# Also show all available options when there is more thanb one
bind "set show-all-if-ambiguous on"

# First Tab press will complete until the first point of ambiguity, a second
# Tab press will start the cycle through the matching options.
bind "set menu-complete-display-prefix on"


# }}}
# Section: iTerm2 integration (MacOS only) {{{
#############################################################################
if is_osx
then
   function iterm2_print_user_vars() {
      # Set a variable with the current git branch
      iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
   }
fi

# }}}


# Get my name from the system to make it easily available everywhere I might
# need it
if is_osx
then
   MYFULLNAME=$(dscl . -read "$HOME" RealName | sed -n -e 's/^ *//' -e '$p')
else
   MYFULLNAME=$(getent passwd "$(whoami)" | cut -d ':' -f 5 | cut -d ',' -f 1)
fi
export MYFULLNAME


# CTRL-D must be used twice to exit the shell
export IGNOREEOF=1

# Enable programmable completion features asynchronously
# See http://superuser.com/a/418112 for details
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
   trap 'source /etc/bash_completion ; trap USR1' USR1
   { sleep 0.1 ; builtin kill -USR1 $$ ; } & disown
fi


if [[ -z $TMUX && -z $SSH_CLIENT ]]; then
   call_if check_home_purity
fi

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

