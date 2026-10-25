# Keep mise's shims first for Bash startup and non-interactive BASH_ENV loads.
# read splits on colons without expanding glob characters in directory names.
IFS=: read -r -a _mise_path <<< "$PATH"
_mise_new_path="$HOME/.local/share/mise/shims"
for _mise_dir in "${_mise_path[@]}"; do
    [[ -z $_mise_dir || $_mise_dir == "$HOME/.local/share/mise/shims" ]] && continue
    _mise_new_path+=":$_mise_dir"
done
export PATH="$_mise_new_path"
unset _mise_path _mise_dir _mise_new_path
