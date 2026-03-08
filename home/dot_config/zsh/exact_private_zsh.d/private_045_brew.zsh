#!/usr/bin/env zsh

# Homebrew configuration {{{
# ----------------------

# If set, do not print any hints about changing Homebrew's behaviour with
# environment variables.
export HOMEBREW_NO_ENV_HINTS=1

# Run brew update once every $HOMEBREW_AUTO_UPDATE_SECS seconds before some
# commands, e.g. brew install, brew upgrade or brew tap. Alternatively, disable
# auto-update entirely with $HOMEBREW_NO_AUTO_UPDATE.
#
# Default: 86400 (24 hours), 3600 (1 hour) if a developer command has been run
# or 300 (5 minutes) if $HOMEBREW_NO_INSTALL_FROM_API is set.
export HOMEBREW_AUTO_UPDATE_SECS=604800  # 1 week

# If set, do not send analytics data to Homebrew's servers.
export HOMEBREW_NO_ANALYTICS=1

# If set, brew bundle dump will not include VSCode (and forks/variants)
# extensions.
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
# }}}


BREW_PATH=
for candidate in \
    "/opt/homebrew/bin/brew" \
    "/home/linuxbrew/.linuxbrew/bin/brew" \
    "/usr/local/bin/brew"
do
    if [[ -e "$candidate" ]]
    then
        BREW_PATH="$candidate"
        break
    fi
done

unset candidate

if [[ -z "$BREW_PATH" ]]
then
    # Homebrew is not installed
    return
fi


eval "$("$BREW_PATH" shellenv)"

# ZSH completions: Homebrew adds its completions to fpath automatically
# via shellenv. We just need to make sure fpath is set before compinit runs.
HOMEBREW_PREFIX="$($BREW_PATH --prefix)"
if [[ -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]]; then
    fpath=("${HOMEBREW_PREFIX}/share/zsh/site-functions" $fpath)
fi

# Wrapper: redirect `brew update <pkg>` to `brew upgrade <pkg>` {{{
# brew update only updates brew itself and doesn't take formula names.
# If positional args are given, the user almost certainly meant `brew upgrade`.
brew() {
    if [[ "$1" == "update" && $# -gt 1 ]]; then
        local has_positional=false
        for arg in "${@:2}"; do
            if [[ "$arg" != -* ]]; then
                has_positional=true
                break
            fi
        done
        if $has_positional; then
            echo "brew update doesn't take formula names. Running 'brew upgrade ${*:2}' instead." >&2
            command brew upgrade "${@:2}"
            return
        fi
    fi
    command brew "$@"
}
# }}}

unset BREW_PATH
