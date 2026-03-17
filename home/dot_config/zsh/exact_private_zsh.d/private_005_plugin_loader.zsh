# Plugin loader with local ignore list support
#
# Reads ~/.config/zsh/plugins_ignore once into an associative array.
# plug::load checks against it and sources the plugin if not ignored.
# plug::is_loaded checks if a plugin was successfully loaded.
#
# Plugin source paths are defined in _plug_source (populated by the
# generated 006_plugin_load.zsh from zsh_plugins.yaml).

typeset -A _plug_ignore=()
typeset -A _plug_loaded=()
typeset -A _plug_source=()
typeset -i _plug_ignore_ready=0

_plug_load_ignore_list() {
    _plug_ignore_ready=1
    local ignore_file=~/.config/zsh/plugins_ignore
    [[ -f $ignore_file ]] || return
    local line
    while IFS= read -r line; do
        # Skip comments and blank lines
        [[ -z $line || $line == \#* ]] && continue
        _plug_ignore[$line]=1
    done < "$ignore_file"
}

plug::load() {
    local name=$1

    # Load ignore list on first call
    if (( ! _plug_ignore_ready )); then
        _plug_load_ignore_list
    fi

    # Skip ignored plugins
    if (( ${+_plug_ignore[$name]} )); then
        return
    fi

    # Look up source path from the registry
    local full_path=${_plug_source[$name]}
    if [[ -z $full_path ]]; then
        return 1
    fi

    if [[ -f $full_path ]]; then
        source "$full_path"
        _plug_loaded[$name]=1
    fi
}

plug::is_loaded() {
    (( ${+_plug_loaded[$1]} ))
}

dot::defer "unset _plug_ignore _plug_loaded _plug_source _plug_ignore_ready"
dot::defer "unfunction _plug_load_ignore_list plug::load plug::is_loaded"
