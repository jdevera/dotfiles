#!/usr/bin/env bash

is_ai_agent && return

function cd
{
    builtin cd "$@" &&
        _cd_ondir &&
        _cd_echo &&
        :
}


function pushd
{
    builtin pushd &&
        _cd_ondir &&
        :
}


function popd
{
    builtin popd &&
        _cd_ondir &&
        :
}


function _cd_init()
{
   cd .
}


# Load the path to ondir for faster access from now on. Replace with a noop if ondir is not available
_ONDIR_PATH=$(which ondir || true)
function _cd_ondir()
{
    [[ -n $_ONDIR_PATH ]] && eval "$("$_ONDIR_PATH" "$OLDPWD" "$PWD")"
}

function _cd_echo()
{
    [[ $PWD != "$OLDPWD" ]] && echo "$PWD (from $OLDPWD)"
}

cd .
