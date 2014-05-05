#!/bin/bash

[[ -z ${GIT_NAME+x}         ]] && read -p "Your Name: "  GIT_NAME
[[ -z ${GIT_EMAIL+x}        ]] && read -p "Your Email: " GIT_EMAIL
[[ -z ${GITHUB_USER+x}      ]] && read -p "GitHub Username: "  GITHUB_USER

cat <<EOF
[user]
    name = $GIT_NAME
    email = $GIT_EMAIL

[github]
    user = $GITHUB_USER

# vim: ft=gitconfig :
EOF

# vim: filetype=sh :
