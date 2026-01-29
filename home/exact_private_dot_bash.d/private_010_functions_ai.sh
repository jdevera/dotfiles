function is_cursor_agent() {
    [[ -n $VSCODE_PID ]] && [[ -n $CURSOR_AGENT ]]
}

function is_ai_agent() {
    is_cursor_agent
}