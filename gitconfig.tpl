#!/bin/bash

[[ -z ${GIT_NAME+x}         ]] && read -p "Your Name: "  GIT_NAME
[[ -z ${GIT_EMAIL+x}        ]] && read -p "Your Email: " GIT_EMAIL
[[ -z ${GITHUB_USER+x}      ]] && read -p "GitHub Username: "  GITHUB_USER

cat <<EOF
[user]
    name = $GIT_NAME
    email = $GIT_EMAIL
[color]
    diff = auto
    status = auto
    branch = auto
    ui = auto
[alias]
    st   = status
    sts  = status --ignore-submodules
    ci   = commit
    br   = branch
    co   = checkout
    df   = diff
    lg   = log -p
    who  = shortlog -s --
    slog = !git --no-pager log --format=oneline --abbrev-commit
    dfnp = !git --no-pager diff
    clog = !git --no-pager log -n 20 --pretty=tformat:'%Cred%h%Creset %ai %Cblue%an%Creset %Cgreen->%Creset %s'
    fuckoff = clean -fdx
    see = !sh -c 'git show $1 | view - -c "set\\ fdm=syntax"' --
[github]
    user = $GITHUB_USER
[push]
	default = simple
[status]
	displayCommentPrefix = false
[color "status"]
    added = "green normal bold"
    changed = "red normal bold"
    untracked = "magenta normal bold"
    header = "cyan normal dim"
    branch = "normal normal bold"
[color "grep"]
	context = cyan normal dim
	selected = normal normal bold
	filename = magenta normal bold
	linenumber = green
	function = blue normal bold
	match = black yellow dim
EOF

# vim: filetype=bash :
