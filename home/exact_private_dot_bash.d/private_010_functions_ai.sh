# @tags: canbescript
function is_cursor_agent() {
    [[ -n $VSCODE_PID ]] && [[ -n $CURSOR_AGENT ]]
}

# @tags: canbescript
function is_ai_agent() {
    is_cursor_agent
}

# @tags: command
# DEPENDS-ON: assert_has_command
function claude-spend()
{
   if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: claude-spend [DAYS]"
      echo "Show a sparkline of daily Claude AI spend."
      echo ""
      echo "  DAYS  Number of days to show (default: 5)"
      return 0
   fi
   assert_has_command ccusage || return 1
   assert_has_command spark || return 1
   local days=${1:-5}
   spark $(ccusage daily --since "$(date -v-"${days}"d +%Y%m%d)" --jq '[.daily[].totalCost][]' --no-color)
}