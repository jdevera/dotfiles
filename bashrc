# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source all files under ~/.bash.d
if [[ -d ~/.bash.d ]]
then
    for conf_file in ~/.bash.d/*
    do
        if [[ -f $conf_file ]]
        then
            source "$conf_file"
        fi
    done
fi


