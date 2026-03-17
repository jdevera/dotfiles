# @name plug
# @brief ZSH plugin loader with ignore list, registry, and on-demand fetching.
# @description
#     Lightweight plugin system for zsh. Plugins can be pre-registered via the
#     generated `006_plugin_load.zsh` (from `zsh_plugins.yaml`) for fast loading,
#     or resolved at runtime from a spec string that supports GitHub repos,
#     multi-plugin repos with subpaths, and arbitrary git URLs.
#
#     An ignore list at `~/.config/zsh/plugins_ignore` allows temporarily
#     disabling plugins locally (one name per line).
#
#     All state (`_plug_source`, `_plug_loaded`, `_plug_ignore`, etc.) and all
#     functions are cleaned up after startup via `dot::defer`.

typeset -gA _plug_ignore=()
typeset -gA _plug_loaded=()
typeset -gA _plug_source=()
typeset -gi _plug_ignore_ready=0

_plug_dir=~/.config/zsh/plugins

# @description Read the ignore list file into `_plug_ignore` on first use.
# @noargs
# @set _plug_ignore_ready int Set to `1` after loading.
# @set _plug_ignore associative-array Plugin names to ignore.
# @internal
_plug_load_ignore_list() {
    _plug_ignore_ready=1
    local ignore_file=~/.config/zsh/plugins_ignore
    [[ -f $ignore_file ]] || return
    local line
    while IFS= read -r line; do
        [[ -z $line || $line == \#* ]] && continue
        _plug_ignore[$line]=1
    done < "$ignore_file"
}

# @description Clone a git repo into the plugins directory if not already present.
# @arg $1 string Git URL or GitHub `user/repo` shorthand.
# @arg $2 string Target directory name under `$_plug_dir`.
# @exitcode 0 Directory already exists or clone succeeded.
# @exitcode 1 Clone failed.
# @stderr Progress and error messages.
# @internal
_plug_fetch() {
    local url=$1 target=$2
    local target_dir=$_plug_dir/$target

    [[ -d $target_dir ]] && return 0

    # Expand GitHub shorthand to full URL
    if [[ $url != *://* ]]; then
        url="https://github.com/${url}.git"
    fi

    echo "plug: cloning $url" >&2
    git clone --quiet "$url" "$target_dir" 2>/dev/null || {
        echo "plug: failed to clone $url" >&2
        return 1
    }
}

# @description Resolve a `plug::load` spec into a plugin name and source file path,
#     fetching the repo if needed.
# @arg $1 string Plugin spec (see `plug::load` for formats).
# @set _resolve_name string Resolved plugin name.
# @set _resolve_path string Full path to the plugin source file.
# @exitcode 0 Resolved successfully.
# @exitcode 1 Repo not found or fetch failed.
# @internal
_plug_resolve() {
    local spec=$1
    local source_override=""

    # Extract source filename override (src@rest)
    if [[ $spec == *@* ]]; then
        source_override=${spec%%@*}
        spec=${spec#*@}
    fi

    local name="" plugin_dir="" source_file=""

    if [[ $spec == *://* ]]; then
        # Full git URL
        name=${${spec:t}%.git}
        _plug_fetch "$spec" "$name" || return 1
        plugin_dir=$_plug_dir/$name

    elif [[ $spec == *:* ]]; then
        # repo:path/in/repo or user/repo:path/in/repo
        local repo_part=${spec%%:*}
        local path_part=${spec#*:}
        local repo_dir

        if [[ $repo_part == */* ]]; then
            # user/repo — fetch if needed
            repo_dir=${repo_part:t}
            _plug_fetch "$repo_part" "$repo_dir" || return 1
        else
            # plain name — must already exist
            repo_dir=$repo_part
            if [[ ! -d $_plug_dir/$repo_dir ]]; then
                echo "plug: repo directory '$repo_dir' not found in $_plug_dir" >&2
                return 1
            fi
        fi

        name=${path_part:t}
        plugin_dir=$_plug_dir/$repo_dir/$path_part

    elif [[ $spec == */* ]]; then
        # user/repo — GitHub shorthand
        name=${spec:t}
        _plug_fetch "$spec" "$name" || return 1
        plugin_dir=$_plug_dir/$name

    else
        # plain name — local plugin, must exist
        name=$spec
        plugin_dir=$_plug_dir/$name
    fi

    source_file=${source_override:-$name}.plugin.zsh
    _resolve_name=$name
    _resolve_path=$plugin_dir/$source_file
}

# @description Load a zsh plugin by spec. Checks the pre-populated registry
#     first (fast path from chezmoi-generated config), then falls back to
#     resolving the spec and fetching from GitHub if needed.
#
#     Warns and skips if a plugin with the same name is already loaded.
#
#     **Spec formats:**
#
#     Base (where to find the plugin):
#     - `name` — local plugin, must already exist in the plugins dir
#     - `user/repo` — GitHub repo, cloned on first use
#     - `https://example.com/repo.git` — arbitrary git URL
#
#     Subpath (load from a directory within the repo, combinable with any base):
#     - `<base>:path/in/repo` — e.g. `ohmyzsh:plugins/git` or `user/repo:lib/foo`
#
#     Source override (use a non-standard `.plugin.zsh` filename, combinable with any of the above):
#     - `src@<spec>` — e.g. `custom@user/repo` loads `custom.plugin.zsh`
#
# @arg $1 string Plugin spec (see formats above). Modifiers can be combined.
#
# @set _plug_loaded associative-array Records the plugin name and its source path on successful load.
#
# @exitcode 0 Plugin loaded successfully.
# @exitcode 1 Plugin ignored, already loaded, not found, or fetch failed.
# @stderr Collision warnings and error messages.
#
# @example
#   plug::load zsh-autosuggestions
#   plug::load zsh-users/zsh-syntax-highlighting
#   plug::load ohmyzsh:plugins/git
#   plug::load ohmyzsh/ohmyzsh:plugins/docker
#   plug::load custom-src@user/repo
plug::load() {
    local spec=$1

    # Load ignore list on first call
    if (( ! _plug_ignore_ready )); then
        _plug_load_ignore_list
    fi

    local name="" full_path=""

    # Fast path: check pre-populated registry first.
    # For registry entries, the name is already known (it's the key).
    # We need to figure out the name from the spec to check ignore/loaded.
    # Parse just the name portion without resolving.
    local check_name=$spec
    # Strip source override
    [[ $check_name == *@* ]] && check_name=${check_name#*@}
    # Strip repo part for colon syntax
    [[ $check_name == *:* ]] && check_name=${${check_name#*:}:t}
    # Strip user/ for GitHub shorthand
    [[ $check_name == */* ]] && check_name=${check_name:t}
    # Strip .git suffix for URLs
    check_name=${check_name%.git}

    # Skip ignored plugins
    if (( ${+_plug_ignore[$check_name]} )); then
        return
    fi

    # Warn on collision
    if (( ${+_plug_loaded[$check_name]} )); then
        echo "plug: '$check_name' already loaded from ${_plug_loaded[$check_name]}, skipping" >&2
        return 1
    fi

    # Fast path: pre-populated registry
    full_path=${_plug_source[$check_name]}

    # Slow path: resolve from spec
    if [[ -z $full_path ]]; then
        local _resolve_name _resolve_path
        _plug_resolve "$spec" || return 1
        name=$_resolve_name
        full_path=$_resolve_path
    else
        name=$check_name
    fi

    if [[ -f $full_path ]]; then
        source "$full_path"
        _plug_loaded[$name]=$full_path
        return 0
    fi

    echo "plug: source file not found: $full_path" >&2
    return 1
}

# @description Check if a plugin was successfully loaded during startup.
# @arg $1 string Plugin name.
# @exitcode 0 Plugin is loaded.
# @exitcode 1 Plugin is not loaded.
#
# @example
#   if plug::is_loaded zsh-autosuggestions; then
#       ZSH_AUTOSUGGEST_STRATEGY=(history completion)
#   fi
plug::is_loaded() {
    (( ${+_plug_loaded[$1]} ))
}

dot::defer "unset _plug_ignore _plug_loaded _plug_source _plug_ignore_ready _plug_dir"
dot::defer "unfunction _plug_load_ignore_list _plug_fetch _plug_resolve plug::load plug::is_loaded"
