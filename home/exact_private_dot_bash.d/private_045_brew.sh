#!/usr/bin/env bash

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