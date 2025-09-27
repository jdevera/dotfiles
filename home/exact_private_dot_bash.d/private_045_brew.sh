#!/usr/bin/env bash

# Homebrew configuration {{{
# ----------------------

# If set, do not print any hints about changing Homebrew’s behaviour with
# environment variables.
export HOMEBREW_NO_ENV_HINTS=1

# Run brew update once every $HOMEBREW_AUTO_UPDATE_SECS seconds before some
# commands, e.g. brew install, brew upgrade or brew tap. Alternatively, disable
# auto-update entirely with $HOMEBREW_NO_AUTO_UPDATE.
#
# Default: 86400 (24 hours), 3600 (1 hour) if a developer command has been run
# or 300 (5 minutes) if $HOMEBREW_NO_INSTALL_FROM_API is set.
export HOMEBREW_AUTO_UPDATE_SECS=604800  # 1 week

# If set, do not send analytics data to Homebrew’s servers.
export HOMEBREW_NO_ANALYTICS=1

# If set, brew bundle dump will not include VSCode (and forks/variants)
# extensions.
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
# }}}


BREW_PATH=
for candidate in \
    "/opt/homebrew/bin/brew" \
    "/home/linuxbrew/.linuxbrew/bin/brew" \
    "/usr/local/bin/brew"
do
    if [[ -e "$candidate" ]]
    then
        BREW_PATH="$candidate"
        break
    fi
done

unset candidate

if [[ -z "$BREW_PATH" ]]
then
    # Homebrew is not installed
    return
fi


eval "$("$BREW_PATH" shellenv)"

# Completions
HOMEBREW_PREFIX="$($BREW_PATH --prefix)"
if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
        [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
fi

# Other paths (shellenv does this)
#MANPATH="$($BREW_PATH --prefix)/share/man:$MANPATH"
#INFOPATH="$($BREW_PATH --prefix)/share/info:$INFOPATH"
#export MANPATH INFOPATH

unset BREW_PATH