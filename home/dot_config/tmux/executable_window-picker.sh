#!/usr/bin/env bash
# tmux command palette — windows, sessions, and custom commands via fzf

# When called with --preview, render preview for the given entry
if [[ $1 == "--preview" ]]; then
    shift
    IFS=$'\t' read -r _ type value <<< "$1"
    case $type in
        window)
            echo "Panes:"
            tmux list-panes -t "$value" -F "  #{pane_index}: #{pane_current_command} (#{pane_current_path})" 2>/dev/null | sed "s|$HOME|~|g"
            ;;
        session)
            echo "Windows:"
            tmux list-windows -t "$value" -F "  #{window_index}: #{window_name} (#{window_panes} panes)" 2>/dev/null
            ;;
        command)
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
CMD_ICON=$'\uf120'

SEP=$'\t'

# Build the list
entries=()

# Windows in current session
while IFS=$'\t' read -r idx name; do
    entries+=("${WIN_ICON}  Win: ${name}${SEP}window${SEP}${idx}")
done < <(tmux list-windows -F "#I	#W")

# Sessions
while IFS=$'\t' read -r name; do
    entries+=("${SESSION_ICON}  Ses: ${name}${SEP}session${SEP}${name}")
done < <(tmux list-sessions -F "#S")

# Commands from palette directory
if [[ -d $PALETTE_DIR ]]; then
    for cmd_file in "$PALETTE_DIR"/*; do
        [[ -f $cmd_file && -x $cmd_file ]] || continue
        cmd_name=$(basename "$cmd_file")
        entries+=("${CMD_ICON}  Cmd: ${cmd_name}${SEP}command${SEP}${cmd_file}")
    done
fi

# Run fzf
selected=$(printf '%s\n' "${entries[@]}" | fzf \
    --ansi \
    --prompt="tmux > " \
    --reverse \
    --no-info \
    --delimiter="$SEP" \
    --with-nth=1 \
    --preview="$SELF --preview {}" \
    --preview-window=wrap)

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
