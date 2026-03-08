# This is the code necessary to bootstrap the ZSH configuration while
# keeping the zshrc file as simple as possible.

# Timing setup {{{

ZSH_TIME_STARTUP=${ZSH_TIME_STARTUP:-0}

if [[ $ZSH_TIME_STARTUP == 1 ]]; then
    zmodload zsh/datetime
    ZSH_TIMES_FILE="/tmp/zshtimes.$$"
    echo -n > "$ZSH_TIMES_FILE"
fi

# }}}
# Functions library {{{

# Set ZSH_TIME_STARTUP to 1 to track the time it takes to load each configuration file.
# The results are stored in a per shell file /tmp/zshtimes.$$ where $$ is the shell pid.
dot::timing::setup()
{
    ZSH_TIME_STARTUP=${ZSH_TIME_STARTUP:-0}
    if [[ $ZSH_TIME_STARTUP == 1 ]]; then
        zmodload zsh/datetime
        ZSH_TIMES_FILE="/tmp/zshtimes.$$"
        echo -n > "$ZSH_TIMES_FILE"
    fi
}

# Unset ZSH_TIME_STARTUP and ZSH_TIMES_FILE to leave the shell clean
dot::timing::teardown()
{
    unset ZSH_TIME_STARTUP
    unset ZSH_TIMES_FILE
    # Unset all functions starting with dot::timing::
    for fn in ${(k)functions[(I)dot::timing::*]}; do
        unset -f "$fn"
    done
}

dot::timing::timed_source()
{
    local file before after
    file="$1"
    before=$EPOCHREALTIME
    source "$file"
    after=$EPOCHREALTIME
    echo "$file $before $after" >> "$ZSH_TIMES_FILE"
}

dot::source_file()
{
    [[ -f $1 ]] || return
    if [[ $ZSH_TIME_STARTUP == 1 ]]
    then
        dot::timing::timed_source "$1"
    else
        source "$1"
    fi
}

dot::source_dir()
{
    local dir=$1
    local sourcer
    if [[ $ZSH_TIME_STARTUP == 1 ]]; then
        sourcer=dot::timing::timed_source
    else
        sourcer=source
    fi
    [[ ! -d $dir ]] && return
    local conf_path
    for conf_path in "$dir"/*(N)
    do
        local filename=${conf_path:t}
        case $filename in
            README*|bootstrap.zsh)
                # Files to exclude from sourcing
                continue
                ;;
            *)
                [[ -f $conf_path ]] && $sourcer "$conf_path"
                ;;
        esac
    done
}

dot::source_zsh_d()
{
    dot::source_dir ~/.config/zsh/zsh.d/local/before
    dot::source_dir ~/.config/zsh/zsh.d
    dot::source_dir ~/.config/zsh/zsh.d/local/after
}
# }}}
