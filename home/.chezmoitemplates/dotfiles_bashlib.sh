# shellcheck shell=bash
__STEP_INDICATOR="=>"
__ERROR_INDICATOR="✗"
__SUCCESS_INDICATOR="✓"
__SKIPPED_INDICATOR="⇊"
__FATAL_INDICATOR="✗"
__INFO_INDICATOR="ℹ"
__WARNING_INDICATOR="⚠"
__DEBUG_INDICATOR="⚙"
__CHEZMOI_INDICATOR="𖠿"

# Check if the terminal supports color output by:
# 1. Checking if stdout is a terminal ([[ -t 1 ]])
# 2. Checking if $TERM is set (test -n "${TERM}")
# 3. Testing if we can set foreground color 0 (black) using tput
function __supports_color() {
    [[ -t 1 ]] && test -n "${TERM}" && tput setaf 0 >& /dev/null
}

function __should_colorize() {
    if [[ -n $NO_COLOR ]]; then
        return 0
    fi
    if [[ -n $FORCE_COLOR ]]; then
        return 1
    fi
    __supports_color
}

function __col() {
    local color=$1
    shift
    if __should_colorize; then
        echo -e "\033[${color}m$*\033[0m"
    else
        echo "$*"
    fi
}

COL_BOLD=
COL_RED=
COL_GREEN=
COL_YELLOW=
COL_BLUE=
COL_MAGENTA=
COL_CYAN=
COL_WHITE=
COL_RESET=
if __should_colorize; then
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
    dot::decorate "$COL_ERROR" "$__ERROR_INDICATOR" "ERROR" "$*" >&2
}

function dot::warn() {
    dot::decorate $COL_WARNING $__WARNING_INDICATOR "WARNING" "$*" >&2
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
    dot::decorate "$COL_INFO" "$__INFO_INDICATOR" "INFO" "$*"
}

function dot::log() {
    echo "$*" >&2
}

function dot::chezmoi_script_start() {
    echo '-----------------------------------------------'
    dot::decorate "$COL_CHEZMOI" "$__CHEZMOI_INDICATOR" "" "$*"
}

function dot::chezmoi_script_skipped() {
    dot::skip "$*"
    exit 0
}

function dot::has_command() {
    command -v "$1" > /dev/null 2>&1
}
