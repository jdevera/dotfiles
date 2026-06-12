#############################################################################
#
# FILE:         010_functions_network.zsh
#
# DESCRIPTION:  Network related functions, aliases, settings, etc
#
#############################################################################



# @tags: command network
function ssh-start-agent()
{
    local agentfile=~/.ssh/agent
    if [[ -f $agentfile ]]
    then
        source $agentfile > /dev/null
        if ps -p "$SSH_AGENT_PID" > /dev/null
        then
            echo "Agent running with PID $SSH_AGENT_PID"
            return
        fi
    fi
    echo "Could not find running agent. Starting new..."
    ssh-agent > $agentfile
    source $agentfile > /dev/null
    echo "Agent running with PID $SSH_AGENT_PID"
    ssh-add
}
