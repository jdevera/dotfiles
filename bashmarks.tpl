#!/bin/bash

sys::is_linux() {
    [[ $(uname -s) == Linux ]]
}

sys::is_macos() {
    [[ $(uname -s) == Darwin ]]
}

cat <<EOF
$HOME/.dotfiles|dot
$HOME/.vim/bundle|bun
$HOME/devel/projects|proj
$HOME/devel/sandbox|sb
$HOME/devel/contributions|cont
$HOME/comms/Dropbox|drop
EOF

if sys::is_macos; then
    cat <<EOF
$HOME/Downloads|dow
EOF
fi

if sys::is_linux; then
    cat <<EOF
$HOME/comms/downloads|dow
EOF
fi

# vim: filetype=sh :
