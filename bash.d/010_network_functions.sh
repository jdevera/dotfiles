#!/bin/bash
#############################################################################
#
# FILE:         031_network.sh
#
# DESCRIPTION:  Network related functions, aliases, settings, etc
#
#############################################################################



##############################################################################
#
# FUNCTION:     getip4
#
# DESCRIPTION:  Show a given network interface's ipv4 address
#
# PARAMETERS:   1 (r): Network interface devide name
#
# DEPENDS-ON:   None
#
##############################################################################
#
getip4()
{
    local a_interface=${1:?"network interface argument missing"}

    ip -o -f inet addr show "$a_interface"     |
        awk '{gsub("/.*", "", $4); print $4}'
}
##############################################################################


function download()
{
    wget --no-use-server-timestamps --no-clobber --directory-prefix="$DDOWN" "$@"
}


http_server()
{
    if has_command python3
    then
        python3 -m http.server ${1:-8000}
    else
        python -m SimpleHTTPServer ${1:-8000}
    fi
}


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

# vim: ft=sh fdm=marker expandtab ts=4 sw=4 :

