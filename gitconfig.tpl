#!/bin/bash

read -p "Your Name: " NAME
read -p "Your Email: " EMAIL
read -p "GitHub Username: " GITHUB_USER
read -p "GitHub API Token: " GITHUB_API_TOKEN

cat <<EOF
[user]
    name = $NAME
    email = $EMAIL
[color]
    diff = auto
    status = auto
    branch = auto
[alias]
    st = status
    ci = commit
    br = branch
    co = checkout
    df = diff
    lg = log -p
    who = shortlog -s --
[github]
    user = $GITHUB_USER
    token = $GITHUB_API_TOKEN
EOF

# vim: filetype=bash :
