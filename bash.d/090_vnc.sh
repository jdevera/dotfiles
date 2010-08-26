#!/bin/bash
#############################################################################
#
# FILE:         090_vnc.sh
#
# DESCRIPTION:  
#
#############################################################################



alias vncstart='vncserver -geometry 1280x700 -depth 16 -name '
alias vncstop='vncserver -kill '
alias getvncport="ps aux | sed -n 's/$USER.*Xvnc.*rfbport \([0-9]\+\).*/\1/p'"
alias getvncstr='echo `hostname -f`::`ps aux | sed -n "s/$USER.*Xvnc.*rfbport \([0-9]\+\).*/\1/p"`'



# vim: ft=bash fdm=marker expandtab ts=3 sw=3 :

