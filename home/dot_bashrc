# ~/.bashrc: executed by bash(1) for non-login shells.
# vim: fdm=marker :

# If not running interactively, don't do anything {{{
[ -z "$PS1" ] && return

# }}}
# Timing setup {{{
BASH_TIME_STARTUP=${BASH_TIME_STARTUP:-0}

if [[ $BASH_TIME_STARTUP == 1 ]]; then
    # Track the time it takes to load each configuration file and store it a
    # per shell file
    bash_times_file="/tmp/bashtimes.$$"
    echo -n > "/tmp/bashtimes.$$"
fi

# }}}
# Functions library {{{

timed_source()
{
    local file="$1"
    local before=$(date +%s%N)
    source "$file"
    local after=$(date +%s%N)
    echo "$file $before $after" >> "$bash_times_file"
}

maybe_source_file()
{
    [[ -f $1 ]] || return
    if [[ $BASH_TIME_STARTUP == 1 ]]
    then
        timed_source "$1"
    else
        source "$1"
    fi
}

source_dir()
{
    local dir=$1
    local sourcer
    if [[ $BASH_TIME_STARTUP == 1 ]]; then
        sourcer='timed_source'
    else
        sourcer='source'
    fi
    if [[ -d $dir ]]
    then
        local conf_file
        for conf_file in "$dir"/*
        do
            if [[ -f $conf_file && $(basename "$conf_file") != 'README' ]]
            then
                $sourcer "$conf_file"
            fi
        done
    fi
}
# }}}

source_dir ~/.bash.d/vendor/bash-preexec  # Source bash-preexec first

source_dir ~/.bash.d/local/before
source_dir ~/.bash.d
source_dir ~/.bash.d/local/after

# Additional files that I generally want to source
maybe_source_file ~/.fzf.bash

# Timing teardown {{{
unset BASH_TIME_STARTUP
unset bash_times_file

# }}}

