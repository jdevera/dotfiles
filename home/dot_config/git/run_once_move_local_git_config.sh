#!/usr/bin/env bash

# This script is used to move the local git config to the correct location
# in the home directory.

if [[ ! -f ~/.gitconfig.local ]]; then
    exit 0
fi

if [[ ! -d ~/.config/git ]]; then
    echo "Error: Moving ~/.gitconfig.local to ~/.config/git/config:" >&2
    echo "    Directory ~/.config/git does not exist" >&2
    exit 1
fi

# Move the local git config to the correct location
mv -v ~/.gitconfig.local ~/.config/git/config.local
