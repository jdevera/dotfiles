# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source_dir()
{
    local dir="$1"
    if [[ -d $dir ]]
    then
        local conf_file
        for conf_file in "$dir"/*
        do
            if [[ -f $conf_file && $(basename $conf_file) != 'README' ]]
            then
                source "$conf_file"
            fi
        done
    fi
}

source_dir ~/.bash.d/local/before
source_dir ~/.bash.d
source_dir ~/.bash.d/local/after

