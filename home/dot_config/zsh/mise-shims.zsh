# Keep mise's shims first, including after macOS path_helper reorders PATH.
# Quoting the filter matches the directory literally, even with glob characters.
path=("${(@)path:#"$HOME/.local/share/mise/shims"}")
# Omit empty entries, as in the Bash setup.
path=("$HOME/.local/share/mise/shims" "${(@)path:#}")
export PATH
