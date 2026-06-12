# @tags: canbescript
function is_cursor_agent() {
    [[ -n $VSCODE_PID ]] && [[ -n $CURSOR_AGENT ]]
}

# @tags: canbescript
function is_ai_agent() {
    is_cursor_agent \
        || [[ -n ${CLAUDECODE:-} ]] \
        || [[ -n ${CODEX_THREAD_ID:-} ]] \
        || [[ -n ${AGENT:-} ]]
}
