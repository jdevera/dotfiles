#!/usr/bin/env bash
# tmux command palette — windows, sessions, and custom commands via fzf
#
# Settings come from the drop-in directory ~/.config/tmux/palette-settings.d:
# every regular *.sh file in it is sourced as bash, in name order (LC_ALL=C),
# so a numeric prefix sets the order and each file sees what earlier ones
# left. A file only sets variables: it may append to, insert into or
# reorder the INDICATORS array (window indicators; the entry format is
# documented in 10-indicators.sh), must print nothing and must not exit.
# A missing or empty directory means no indicators.

# Window indicator registry (INDICATORS), used by the list and the preview
INDICATORS=()
SETTINGS_DIR=~/.config/tmux/palette-settings.d
if [[ -d $SETTINGS_DIR ]]; then
    while IFS= read -r settings_file; do
        [[ -f $settings_file && -r $settings_file ]] && source "$settings_file"
    done < <(printf '%s\n' "$SETTINGS_DIR"/*.sh | LC_ALL=C sort)
fi

# Entry lines are TAB-separated: display, type, value, and for windows a
# last, hidden field with the tags of the window's indicators (possibly
# empty). Only the display is shown; the search covers display and tags.

# When called with --filter QUERY LIST, print the rows of LIST matching
# QUERY, best first. fzf never searches fields that --with-nth hides, so
# the picker runs fzf with --disabled and every keystroke reloads the list
# through here: fzf --filter over a plain copy of each row (display with
# ANSI codes stripped, plus the tags), mapped back to the original rows
# (colors intact) in fzf's score order.
if [[ $1 == "--filter" ]]; then
    query=$2 list=$3
    if [[ -z $query ]]; then
        cat "$list"
        exit 0
    fi
    rows=()
    while IFS= read -r row; do rows+=("$row"); done < "$list"
    for i in "${!rows[@]}"; do
        IFS=$'\t' read -r display _ _ tags <<< "${rows[i]}"
        printf '%s\t%s\t%s\n' "$i" "$display" "$tags"
    done | sed $'s/\e\\[[0-9;]*m//g' \
        | fzf --filter "$query" --delimiter=$'\t' --nth=2,3 \
        | while IFS=$'\t' read -r i _; do printf '%s\n' "${rows[i]}"; done
    exit 0
fi

# When called with --preview, render preview for the given entry
if [[ $1 == "--preview" ]]; then
    shift
    IFS=$'\t' read -r _ type value _ <<< "$1"
    case $type in
        window)
            echo "Window: $(tmux display-message -p -t ":$value" "#{window_name}")"
            # Evaluate every indicator condition for this window in one call
            fmt=
            for entry in "${INDICATORS[@]}"; do
                IFS='|' read -r cond _ <<< "$entry"
                fmt+="#{?${cond},1,0}"
            done
            hits=$(tmux display-message -p -t ":$value" "$fmt")
            n=0
            for entry in "${INDICATORS[@]}"; do
                IFS='|' read -r _ icon label _ <<< "$entry"
                [[ ${hits:n:1} == 1 ]] && echo "  ${icon:-•} ${label}"
                ((n++))
            done
            echo
            echo "Panes:"
            tmux list-panes -t "$value" -F "  #{pane_index}: #{pane_current_command} (#{pane_current_path})" 2>/dev/null | sed "s|$HOME|~|g"
            ;;
        session)
            echo "Session: ${value}"
            [[ $value == "$(tmux display-message -p '#S')" ]] && echo "  • current session"
            echo
            echo "Windows:"
            tmux list-windows -t "$value" -F "  #{window_index}: #{window_name} (#{window_panes} panes)" 2>/dev/null
            ;;
        command)
            echo "Command: $(basename "$value")"
            echo
            if command -v shdoc-ng &>/dev/null; then
                if command -v lowdown &>/dev/null; then
                    COLUMNS=10000 shdoc-ng generate -i "$value" 2>/dev/null | COLUMNS=10000 lowdown -Tterm --term-width=10000 --term-columns=10000 | sed 's/^    //'
                else
                    shdoc-ng generate -i "$value" 2>/dev/null
                fi
            else
                # Fall back to @brief or first comment line
                sed -n 's/^# @brief //p; /^# @/!s/^# //p' "$value" 2>/dev/null | head -3
            fi
            ;;
    esac
    exit 0
fi

PALETTE_DIR=~/.config/tmux/palette.d
SELF=$(realpath "$0")

WIN_ICON="󰨇"
SESSION_ICON="󱕯"
CMD_ICON=$''

SEP=$'\t'

# Flag indicators shown after the window name, one #{?COND,ICON ,} per
# registry entry, and the matching search tags, one #{?COND,TAG ,} per
# entry that has a tag.
FLAGS_FMT=""
TAGS_FMT=""
RED_ICONS=()
for entry in "${INDICATORS[@]}"; do
    IFS='|' read -r cond icon _ color tag _ <<< "$entry"
    FLAGS_FMT+="#{?${cond},${icon} ,}"
    [[ -n $tag ]] && TAGS_FMT+="#{?${cond},${tag} ,}"
    [[ $color == red ]] && RED_ICONS+=("$icon")
done
RED=$'\e[31m'
RESET=$'\e[0m'
DIM=$'\e[2m'
UNDIM=$'\e[22m'

# Build the list
entries=()

# Windows in current session. Flags and tags may both be empty, and tab is
# IFS whitespace: `read` would collapse an empty field into its neighbor.
# Each is emitted behind a ":" so no field is ever empty, then stripped.
while IFS=$'\t' read -r idx name flags tags; do
    flags=${flags#:}
    tags=${tags#:}
    if [[ -n $flags ]]; then
        flags=${flags% }
        for icon in "${RED_ICONS[@]}"; do flags=${flags//$icon/${RED}${icon}${RESET}}; done
        flags=" ${flags}"
    fi
    tagsdisp=""
    [[ -n $tags ]] && tagsdisp="    ${DIM}[${tags% }]${UNDIM}"
    entries+=("${WIN_ICON}  W: ${name}${flags}${tagsdisp}${SEP}window${SEP}${idx}${SEP}${tags% }")
done < <(tmux list-windows -F "#I	#W	:${FLAGS_FMT}	:${TAGS_FMT}")

# Commands may declare "# @enabled-if <tmux format condition>"; it is
# evaluated against the current window (the pane the popup opened over
# when tmux names it, else the client's current window), and an entry
# whose condition is false is dimmed. Dimmed entries stay selectable.
CURRENT=()
[[ -n $TMUX_PANE ]] && CURRENT=(-t "$TMUX_PANE")

# Sessions
while IFS=$'\t' read -r name; do
    entries+=("${SESSION_ICON}  S: ${name}${SEP}session${SEP}${name}")
done < <(tmux list-sessions -F "#S")

# Commands from palette directory
if [[ -d $PALETTE_DIR ]]; then
    for cmd_file in "$PALETTE_DIR"/*; do
        [[ -f $cmd_file && -x $cmd_file ]] || continue
        cmd_name=$(basename "$cmd_file")
        label="${CMD_ICON}  C: ${cmd_name}"
        cond=$(sed -n 's/^# @enabled-if //p' "$cmd_file")
        cond=${cond%%$'\n'*}
        if [[ -n $cond && $(tmux display-message -p "${CURRENT[@]}" "#{?${cond},1,0}") == 0 ]]; then
            label="${DIM}${label}${UNDIM}"
        fi
        entries+=("${label}${SEP}command${SEP}${cmd_file}")
    done
fi

# Run fzf. TRIAL: tags are shown dimmed in the display, so fzf searches
# natively and highlights matches; the --filter machinery above is idle.
LIST=$(mktemp "${TMPDIR:-/tmp}/window-picker.XXXXXX")
trap 'rm -f "$LIST"' EXIT
printf '%s\n' "${entries[@]}" > "$LIST"
selected=$(fzf \
    --ansi \
    --tiebreak=index \
    --prompt="tmux > " \
    --reverse \
    --no-info \
    --delimiter="$SEP" \
    --with-nth=1 \
    --preview="$SELF --preview {}" \
    --preview-window=wrap < "$LIST")
rm -f "$LIST"

[[ -z $selected ]] && exit 0

# Parse selection
type=$(echo "$selected" | cut -d"$SEP" -f2)
value=$(echo "$selected" | cut -d"$SEP" -f3)

case $type in
    window)
        tmux select-window -t "$value"
        ;;
    session)
        tmux switch-client -t "$value"
        ;;
    command)
        exec "$value"
        ;;
esac
