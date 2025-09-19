# This is the code necessary to boostrap the bash configuration while
# keeping the bashrc file as simple as possible.

# Warn if bash is not v5 or newer:
if [[ ${BASH_VERSINFO[0]} -lt 5 ]]; then
    echo "Warning: This shell config expects Bash v5 or newer. You are using Bash v${BASH_VERSINFO[0]}"
fi

# Timing setup {{{

BASH_TIME_STARTUP=${BASH_TIME_STARTUP:-0}

if [[ $BASH_TIME_STARTUP == 1 ]]; then
    BASH_TIMES_FILE="/tmp/bashtimes.$$"
    echo -n > "$BASH_TIMES_FILE"
fi

# }}}
# Functions library {{{

# Set BASH_TIME_STARTUP to 1 to track the time it takes to load each configuration file.
# The results are stored in a per shell file /tmp/bashtimes.$$ where $$ is the shell pid.
dot::timing::setup()
{
    BASH_TIME_STARTUP=${BASH_TIME_STARTUP:-0}
    if [[ $BASH_TIME_STARTUP == 1 ]]; then
        BASH_TIMES_FILE="/tmp/bashtimes.$$"
        echo -n > "$BASH_TIMES_FILE"
    fi
}

# Unset BASH_TIME_STARTUP and BASH_TIMES_FILE to leave the shell clean
dot::timing::teardown()
{
    unset BASH_TIME_STARTUP
    unset BASH_TIMES_FILE
    # Unset all functions starting with dot::timing::
    for fn in $(compgen -A function dot::timing::); do
        unset -f "$fn"
    done
}

dot::timing::timed_source()
{
    local file before after
    file="$1"
    before=$EPOCHREALTIME
    # shellcheck source=/dev/null
    source "$file"
    after=$EPOCHREALTIME
    echo "$file $before $after" >> "$BASH_TIMES_FILE"
}

dot::source_file()
{
    [[ -f $1 ]] || return
    if [[ $BASH_TIME_STARTUP == 1 ]]
    then
        dot::timing::timed_source "$1"
    else
        # shellcheck source=/dev/null
        source "$1"
    fi
}

dot::source_dir()
{
    local dir=$1
    local sourcer
    if [[ $BASH_TIME_STARTUP == 1 ]]; then
        sourcer=dot::timing::timed_source
    else
        sourcer=source
    fi
    [[ ! -d $dir ]] && return
    local conf_path
    for conf_path in "$dir"/*
    do
        local filename=${conf_path##*/}
        case $filename in
            README|bootstrap.sh)
                # Files to exclude from sourcing
                continue
                ;;
            *)
                [[ -f $conf_path ]] && $sourcer "$conf_path"
                ;;
        esac
    done
}

dot::source_vendored()
{
    local path=$1
    dot::source_file "$HOME/.bash.d/vendor/$path"
}

dot::source_bash_d()
{
    dot::source_dir ~/.bash.d/local/before
    dot::source_dir ~/.bash.d
    dot::source_dir ~/.bash.d/local/after
}
# }}}