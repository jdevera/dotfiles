# Path bookmarks: cd-NAME aliases with cdd completion
# Loaded before bashmarks (200) so both coexist

# Register a path bookmark: creates a cd-NAME alias
bookmark() {
    local name=$1 dir=$2
    alias "cd-${name}=cd ${(q)dir}"
}

# Source managed bookmarks
[[ -f ~/.config/path_bookmarks/dotfiles.bookmarks ]] && source ~/.config/path_bookmarks/dotfiles.bookmarks

# Source local bookmarks (machine-specific, untracked)
[[ -f ~/.config/path_bookmarks/local.bookmarks ]] && source ~/.config/path_bookmarks/local.bookmarks

# cdd: jump to a bookmark by name, or list all with no args
cdd() {
    if [[ $# -eq 0 ]]; then
        local name
        for name in "${(@ok)aliases[(I)cd-*]}"; do
            local short="${name#cd-}"
            local dir="${aliases[$name]#cd }"
            printf "%-10s %s\n" "$short" "$dir"
        done
        return
    fi
    local cmd="cd-$1"
    if (( $+aliases[$cmd] )); then
        eval "$aliases[$cmd]"
    else
        echo "Unknown bookmark: $1" >&2
        return 1
    fi
}

# Tab completion for cdd: shows name -- target_path
_cdd() {
    local -a items
    local name
    for name in "${(@ok)aliases[(I)cd-*]}"; do
        local short="${name#cd-}"
        local dir="${aliases[$name]#cd }"
        items+=("${short}:${dir}")
    done
    _describe 'bookmark' items
}
compdef _cdd cdd
