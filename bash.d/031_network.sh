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
    a_interface=${1:?"network interface argument missing"}

    ip -o -f inet addr show "$a_interface"     |
        awk '{gsub("/.*", "", $4); print $4}'
}
##############################################################################

alias ip0='getip4 eth0'

# vim: ft=bash fdm=marker expandtab ts=4 sw=4 :

