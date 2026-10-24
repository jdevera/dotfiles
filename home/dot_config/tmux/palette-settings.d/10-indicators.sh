# Window indicators for the tmux command palette (window-picker.sh): the
# generic tmux window flags. Sourced as bash by the picker, together with
# the other *.sh files in this directory, in name order. Later files may
# append to, insert into or reorder INDICATORS; list order is display order.
#
# One entry per element of INDICATORS, fields separated by "|":
#
#   tmux format condition | icon | preview label | color | tag
#
# - condition: tmux format that is true ("1") for a window that has the
#   indicator, e.g. #{window_bell_flag} or #{==:#{@my_option},1}. It must
#   not contain "|", "," or "}" outside nested #{...}.
# - icon: one nerd font glyph, shown after the window name in the list
#   (in list order) and as the bullet in the preview.
# - label: text after the icon in the preview.
# - color: optional; only "red" is used (the list icon is wrapped in red).
# - tag: optional; one plain word for search, never displayed. The picker
#   appends the tags of a window's indicators to its row as a hidden
#   field, so typing the tag filters to those windows. Leave it empty (or
#   drop the field) for indicators not worth a search.
# Comments and blank lines are fine; remove an entry to drop the indicator.
# Glyph reference: https://www.nerdfonts.com/cheat-sheet
#
# Icons: map_marker U+F034E, bell U+F00DE, lightning U+F140B, magnify
# U+F0349, bookmark U+F00C0, bell_sleep U+F009B.

INDICATORS+=(
    "#{window_active}|󰍎|current window|"
    "#{window_bell_flag}|󰃞|bell rang|red"
    "#{window_activity_flag}|󱐋|activity since last visit|"
    "#{window_zoomed_flag}|󰍉|active pane is zoomed|"
    "#{window_marked_flag}|󰃀|contains the marked pane|"
    "#{window_silence_flag}|󰂛|has gone silent|"
)
