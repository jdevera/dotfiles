#!/bin/zsh
#############################################################################
#
# FILE:         050_misc_config.zsh
#
# DESCRIPTION:  Main ZSH configuration
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
export DDOWN=$HOME/comms/downloads
export DZSH=$HOME/.config/zsh/zsh.d

export PROJECT_HOME=$HOME/devel/myforge/projects

# Some MacOS overrides
if is_osx
then
   export DDOWN=$HOME/Downloads
   export PROJECT_HOME=$HOME/devel/projects
fi

export NPM_PACKAGES="$HOME/.npm-packages"

#############################################################################

# }}}
# Section: PATH {{{
#############################################################################

pathprepend /usr/local/sbin

# Add user's Cabal binaries to the path
pathprepend "$HOME/.cabal/bin"

pathprepend "$HOME/.local/bin"
pathprepend "$HOME/.gem/ruby/1.9.1/bin"
pathprepend "$HOME/.gem/ruby/2.3.0/bin"
pathprepend "$HOME/.cargo/bin"
export VOLTA_HOME="$HOME/.volta"
pathprepend "$VOLTA_HOME/bin"

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
   eval "$(pyenv init - zsh)"
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
export LESS_TERMCAP_so=$'\E[1;37;7m'      # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#############################################################################

# }}}
# Section: Prompt {{{
#############################################################################

if has_command starship
then
   # When zsh is launched from within bash (e.g. during a shell migration),
   # it inherits STARSHIP_CONFIG which bash may have set to an ASCII-only
   # prompt for terminals with Unicode issues (see starship/starship#6923).
   # This is a bash-specific workaround that doesn't apply to zsh, so we
   # detect it via a sentinel variable and clear it to use the default config.
   if [[ -n "$_STARSHIP_CONFIG_SET_BY_BASH" && "$STARSHIP_CONFIG" == "$_STARSHIP_CONFIG_SET_BY_BASH" ]]; then
      unset STARSHIP_CONFIG
      unset _STARSHIP_CONFIG_SET_BY_BASH
   fi
   eval -- "$(starship init zsh)"
else
   echo "No starship, this is the path: $PATH"
fi


#############################################################################

# }}}
# Section: History {{{
#############################################################################

# Disable history recording in AI agent shells to avoid polluting history
# with massive auto-generated commands from coding agents.
if is_ai_agent; then
   HISTFILE=/dev/null
   HISTSIZE=0
   SAVEHIST=0
else
   # ZSH history configuration
   HISTFILE=${HISTFILE:-$HOME/.zsh_history}
   HISTSIZE=5000
   SAVEHIST=20000

   # Append history instead of overwriting
   setopt APPEND_HISTORY

   # Share history between all sessions
   setopt SHARE_HISTORY

   # Don't record commands starting with a space
   setopt HIST_IGNORE_SPACE

   # Remove duplicates from history when it fills up
   setopt HIST_EXPIRE_DUPS_FIRST

   # Don't record duplicate consecutive commands
   setopt HIST_IGNORE_DUPS

   # Add timestamps to history
   setopt EXTENDED_HISTORY

   # Write to history immediately, not when shell exits
   setopt INC_APPEND_HISTORY
fi

#############################################################################

# }}}
# Section: ZSH Options {{{
#############################################################################

# Type a directory name to cd into it
setopt AUTO_CD

# cd pushes onto dir stack automatically
setopt AUTO_PUSHD

# No duplicates in dir stack
setopt PUSHD_IGNORE_DUPS

# Allow # comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Silence
setopt NO_BEEP

# Correct minor directory spelling errors in cd
setopt CORRECT

# Extended globbing (^, ~, # operators)
setopt EXTENDED_GLOB

# Don't error on no glob match, pass the pattern through
setopt NO_NOMATCH

# Null glob: expand to nothing on no match (for specific globs)
# Note: NO_NOMATCH above is the default, use (N) qualifier where needed

#############################################################################

# }}}
# Section: Key Bindings {{{
#############################################################################

# Use complete-word instead of the default expand-or-complete. This skips
# expansion (globs, aliases, variables) and jumps straight to completion,
# avoiding unexpected substitutions like $PWD expanding into a full path.
bindkey '^I' complete-word

# Cycle in reverse with Shift-Tab
bindkey '^[[Z' reverse-menu-complete

# Ctrl-X Ctrl-E: edit command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

#############################################################################

# }}}
# Section: iTerm2 integration (MacOS only) {{{
#############################################################################
if is_osx
then
   function iterm2_print_user_vars() {
      # Set a variable with the current git branch
      iterm2_set_user_var gitBranch "$(git branch 2> /dev/null | grep -F '*' | cut -c3-)"
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
