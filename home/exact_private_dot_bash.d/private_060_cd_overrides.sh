#!/usr/bin/env bash

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
_ONDIR_PATH=$(which ondir || echo :)
_cd_ondir()
{
   local ondir_path=${_ONDIR_PATH:-':'}
   eval "$("$ondir_path" "$OLDPWD" "$PWD")"
}

_cd_echo()
{
    [[ $PWD != $OLDPWD ]] && echo "$PWD (from $OLDPWD)"
}

cd .
