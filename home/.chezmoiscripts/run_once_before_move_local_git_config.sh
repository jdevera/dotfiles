#!/usr/bin/env bash

# This script is used to move the local git config to the correct location
# in the home directory.

if [[ ! -f ~/.gitconfig.local ]]; then
    exit 0
fi

echo "Moving ~/.gitconfig.local to ~/.config/git/config.local"

if [[ ! -d ~/.config/git ]]; then
    mkdir -p ~/.config/git
fi

# Move the local git config to the correct location
mv ~/.gitconfig.local ~/.config/git/config.local
