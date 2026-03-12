# Path bookmarks: cd-NAME aliases with cdd completion
# Loaded before bashmarks (200) so both coexist

# Register a path bookmark: creates a cd-NAME alias
bookmark() {
    local name=$1 dir=$2
    # shellcheck disable=SC2139
    alias "cd-${name}=cd \"${dir}\""
}

# Source managed bookmarks
[[ -f ~/.config/path_bookmarks/dotfiles.bookmarks ]] && source ~/.config/path_bookmarks/dotfiles.bookmarks

# Source local bookmarks (machine-specific, untracked)
[[ -f ~/.config/path_bookmarks/local.bookmarks ]] && source ~/.config/path_bookmarks/local.bookmarks

# cdd: jump to a bookmark by name, or list all with no args
cdd() {
    if [[ $# -eq 0 ]]; then
        alias | grep '^alias cd-' | sed "s/^alias cd-//;s/='cd /\t/;s/'$//"
        return
    fi
    local cmd="cd-$1"
    if alias "$cmd" &>/dev/null; then
        eval "$cmd"
    else
        echo "Unknown bookmark: $1" >&2
        return 1
    fi
}

# Bash completion for cdd
_cdd_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local names
    names=$(alias | sed -n 's/^alias cd-\([^=]*\)=.*/\1/p')
    COMPREPLY=($(compgen -W "$names" -- "$cur"))
}
complete -F _cdd_complete cdd
