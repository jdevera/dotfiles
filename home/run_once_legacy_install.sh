#!/usr/bin/env bash

die() {
    echo "$*" >&2
    exit 1
}

echo
echo ">>> 🎬 Starting legacy install script"
echo

export DOTFILES_OVERWRITE_REPLY=y
export DOTFILES_SKIP_VIM_PLUGINS=1

cd "$CHEZMOI_WORKING_TREE" || die "Cannot cd into Chezmoi working tree: $CHEZMOI_WORKING_TREE"
[[ -f ./install ]] || die "Could not find install script"


./install

echo
echo ">>> 🏁 Finished legacy install script"
echo
