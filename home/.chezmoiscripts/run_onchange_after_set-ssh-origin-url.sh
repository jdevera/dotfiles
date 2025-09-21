#!/usr/bin/env bash

PREVIOUS_ORIGIN=$(git -C "$CHEZMOI_WORKING_TREE" remote get-url origin)
NEW_ORIGIN="${PREVIOUS_ORIGIN/#https:\/\/github.com\//git@github.com:}"
if [[ "$PREVIOUS_ORIGIN" != "$NEW_ORIGIN" ]]; then
    git -C "$CHEZMOI_WORKING_TREE" remote set-url origin "$NEW_ORIGIN"
fi
