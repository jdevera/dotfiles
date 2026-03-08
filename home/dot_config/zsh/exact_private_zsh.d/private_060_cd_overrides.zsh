#!/usr/bin/env zsh

is_ai_agent && return

# ZSH's chpwd hook runs after every directory change (cd, pushd, popd)
# No need to override individual builtins like in Bash
chpwd() {
    _cd_ondir
    _cd_echo
}

# Load the path to ondir for faster access from now on. Replace with a noop if ondir is not available
_ONDIR_PATH=$(whence -p ondir || true)
function _cd_ondir()
{
    [[ -n $_ONDIR_PATH ]] && eval "$("$_ONDIR_PATH" "$OLDPWD" "$PWD")"
}

function _cd_echo()
{
    [[ $PWD != "$OLDPWD" ]] && echo "$PWD (from $OLDPWD)"
}

cd .
