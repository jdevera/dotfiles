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
# @tags: command canbescript network
function getip4()
{
    local a_interface=${1:?"network interface argument missing"}

    ip -o -f inet addr show "$a_interface"     |
        awk '{gsub("/.*", "", $4); print $4}'
}
##############################################################################


# @tags: command canbescript network
function download()
{
    wget --no-use-server-timestamps --no-clobber --directory-prefix="$DDOWN" "$@"
}


# @tags: command canbescript network
function http_server()
{
    python3 -m http.server "${1:-8000}"
}


# shellcheck source=/dev/null
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

# @tags: command canbescript network
# DEPENDS-ON: download
function getfavicon()
{
   local url="$1/favicon.ico"
   local name="$2"
   if [[ -z $name ]]; then
      name="$(python -c 'import sys,urlparse; print urlparse.urlparse(sys.argv[1]).netloc.replace(".", "_")' "$1")"
   fi
   local favdir="$DDOWN/favicons"
   mkdir -p "$favdir"
   DDOWN="$favdir" download "$url" && mv "$favdir/favicon.ico" "$favdir/${name}.ico"
}

# vim: ft=sh fdm=marker expandtab ts=4 sw=4 :

