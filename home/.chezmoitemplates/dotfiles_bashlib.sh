# shellcheck shell=bash
# Check if the terminal supports color output by:
# 1. Checking if stdout is a terminal ([[ -t 1 ]])
# 2. Checking if $TERM is set (test -n "${TERM}")
# 3. Testing if we can set foreground color 0 (black) using tput
function __dot_supports_color() {
    [[ -t 1 ]] && test -n "${TERM}" && tput setaf 0 >& /dev/null
}

function __dot_should_colorize() {
    [[ -n $NO_COLOR ]] && return 0
    if [[ -n $FORCE_COLOR ]]; then
        return 1
    fi
    __dot_supports_color
}

function __dot_col() {
    local color=$1
    shift
    if __dot_should_colorize; then
        echo -e "\033[${color}m$*\033[0m"
    else
        echo "$*"
    fi
}

# Colors
# -----------------------------------------------------------------------------
COL_BOLD=
COL_RED=
COL_GREEN=
COL_YELLOW=
COL_BLUE=
COL_MAGENTA=
COL_CYAN=
COL_WHITE=
COL_RESET=
if __dot_should_colorize; then
    COL_BOLD=$'\e[1m'
    COL_RED=$'\e[1;31m'
    COL_GREEN=$'\e[1;32m'
    COL_YELLOW=$'\e[1;33m'
    COL_BLUE=$'\e[1;34m'
    COL_MAGENTA=$'\e[1;35m'
    COL_CYAN=$'\e[1;36m'
    COL_WHITE=$'\e[1;37m'
    COL_RESET=$'\e[0m'
fi
COL_STEP=$COL_BLUE
COL_ERROR=$COL_RED
COL_WARNING=$COL_YELLOW
COL_INFO=$COL_CYAN
COL_CHEZMOI=$COL_BOLD$COL_BLUE
COL_SKIPPED=$COL_CYAN
COL_SUCCESS=$COL_GREEN$COL_BOLD
# -----------------------------------------------------------------------------

# Indicators
# -----------------------------------------------------------------------------
__STEP_INDICATOR="=>"
__ERROR_INDICATOR="✗"
__SUCCESS_INDICATOR="✓"
__SKIPPED_INDICATOR="⇊"
__FATAL_INDICATOR="✗"
__INFO_INDICATOR="ℹ"
__WARNING_INDICATOR="⚠"
__DEBUG_INDICATOR="⚙"
__CHEZMOI_INDICATOR="𖠿"
# -----------------------------------------------------------------------------

# Other
# -----------------------------------------------------------------------------
__SCRIPT_LABEL=""
__STEP_LABEL=""
__STEP_NUMBER=0
# -----------------------------------------------------------------------------

# Functions
# -----------------------------------------------------------------------------

function dot::decorate() {
    local color=$1
    local indicator=$2
    local label=${3}
    shift 3
    if [[ -n $label ]]; then
        label=" ${label}"
    fi
    echo "${color}${indicator}${label}${COL_RESET}: ${COL_BOLD}$*${COL_RESET}"
}

function dot::step() {
    dot::decorate "$COL_STEP" "$__STEP_INDICATOR" "" "$*"
}

function dot::error() {
    dot::decorate "$COL_ERROR" "$__ERROR_INDICATOR" "Error" "$*" >&2
}

function dot::warn() {
    dot::decorate "$COL_WARNING" "$__WARNING_INDICATOR" "Warning" "$*" >&2
}

function dot::skip() {
    dot::decorate "$COL_SKIPPED" "$__SKIPPED_INDICATOR" "Skipping" "$*" >&2
}

function dot::die() {
    dot::error "$*"
    exit 1
}

function dot::success() {
    dot::decorate "$COL_SUCCESS" "$__SUCCESS_INDICATOR" "" "$*"
}

function dot::info() {
    dot::decorate "$COL_INFO" "$__INFO_INDICATOR" "Info" "$*"
}

function dot::log() {
    echo "$*" >&2
}

function dot::chezmoi_script_start() {
    __SCRIPT_LABEL="$*"
    echo '-----------------------------------------------'
    dot::decorate "$COL_CHEZMOI" "$__CHEZMOI_INDICATOR" "Chezmoi Script" "$__SCRIPT_LABEL" >&2
}

function dot::chezmoi_script_skipped() {
    dot::skip "$*"
    exit 0
}

function dot::step::start() {
    if [[ -n $__STEP_LABEL ]]; then
        dot::step::done
    fi
	__STEP_NUMBER=$((__STEP_NUMBER + 1))
	__STEP_LABEL="$1"
    dot::decorate "$COL_STEP" "$__STEP_INDICATOR" "Step $__STEP_NUMBER" "will $__STEP_LABEL" >&2
}

# shellcheck disable=SC2120 # allow optional arguments
function dot::step::done() {
    local sep=""
    [[ -n $1 ]] && sep=": "
    dot::decorate "$COL_SUCCESS" "$__SUCCESS_INDICATOR " "Step $__STEP_NUMBER" "did  $__STEP_LABEL" "$sep$*" >&2
    __STEP_LABEL=""
}
    
function dot::step::skipped() {
    local sep=""
    [[ -n $1 ]] && sep=": "
    dot::decorate "$COL_SKIPPED" "$__SKIPPED_INDICATOR " "Step $__STEP_NUMBER skipped" "$__STEP_LABEL" "$sep$*" >&2
    __STEP_LABEL=""
}

function dot::step::error() {
    local sep=""
    [[ -n $1 ]] && sep=": "
    dot::decorate "$COL_ERROR" "$__ERROR_INDICATOR " "Step $__STEP_NUMBER error" "could not $__STEP_LABEL" "$sep$*" >&2
    __STEP_LABEL=""
}

# shellcheck disable=SC2120 # allow optional arguments
function dot::step::fatal() {
    local sep=""
    [[ -n $1 ]] && sep=": "
    dot::decorate "$COL_ERROR" "$__ERROR_INDICATOR " "Step $__STEP_NUMBER fatal" "could not $__STEP_LABEL" "$sep$*" >&2
    exit 1
}

function dot::has_command() {
    command -v "$1" > /dev/null 2>&1
}

macos::defaults::matches()
{
    local domain key type value
    domain=$1
    key=$2
    type=$3
    value=$4
    if [[ $type == "boolean" ]]; then
        if [[ $value == "true" ]]; then
            value=1
        else
            value=0
        fi
    fi
    if ! current_value=$(defaults read "$domain" "$key" 2>/dev/null); then
        return 1
    fi
    if [[ "$current_value" != "$value" ]]; then
        return 1
    fi

    current_type=$(defaults read-type "$domain" "$key")
    current_type=${current_type#Type is }
    if [[ "$current_type" != "$type" ]]; then
        return 1
    fi
    return 0
}


dot::step::macos::defaults::set()
{
    local domain key type value label
    domain=$1
    key=$2
    type=$3
    value=$4
    shift 4
    label=$*
    dot::step::start "$label"

    if macos::defaults::matches "$domain" "$key" "$type" "$value"; then
        dot::step::skipped "already set"
    else
        defaults write "$domain" "$key" "-$type" "$value" || dot::step::fatal
        dot::step::done
    fi
}