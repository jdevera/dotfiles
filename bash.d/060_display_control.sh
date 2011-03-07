#!/bin/bash
#############################################################################
#
# FILE:         060_display_control.sh
#
# DESCRIPTION:  
#
#############################################################################

case "$HOSTNAME" in
aurora)
    # Intel graphics card
    alias displaylcd='xrandr --output LVDS1 --mode 1440x900 && xrandr --output TV1   --off --output VGA1 --off'
    alias displaytv='xrandr  --output TV1   --mode 1024x768 && xrandr --output LVDS1 --off --output VGA1 --off'
    alias displayvga='xrandr --output VGA1  --mode 1920x1200 && xrandr --output LVDS1 --off --output TV1  --off'
    alias displayboth='xrandr --output VGA1 --primary && xrandr --output VGA1 --auto --pos 0x0 --output LVDS1 --auto --right-of VGA1'
    ;;
helicon|solaria)
    # Nvidia cards
    alias displaylcd='disper -s'
    alias displayvga='disper -S'
    alias displayboth='disper -e -t left'
esac


alias displayleft='xrandr -o left'
alias displayright='xrandr -o right'

# vim: ft=bash fdm=marker expandtab ts=3 sw=3 :

