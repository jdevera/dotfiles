#!/bin/bash
#____________________________________________________________________________
#
# FILE:         011_persistent_history.sh
#
# DESCRIPTION:  Code related to persistent history functionality across all
#               open shells
#
#____________________________________________________________________________

log_bash_persistent_history()
{
   local LAST_RC=${LAST_RC:-$?}
   local HISTTIMEFORMAT="%Y-%m-%d %T %z "
   [[
      $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+\ [^\ ]+)\ +(.*)$
   ]]
   local date_part="${BASH_REMATCH[1]}"
   local command_part="${BASH_REMATCH[2]}"
   if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
   then
      echo "$date_part | $PWD | $LAST_RC | $command_part" >> ~/.persistent_history
      export PERSISTENT_HISTORY_LAST="$command_part"
   fi
}

phack()
{
   ack "$@" ~/.persistent_history
}

color_phist()
{
   colout '^([^\|]+)(\|)([^|]+)(\|) (?:(\?)|(0)|([1-9]\d*)) (\|)(.*)$' 208,21,238,21,yellow,green,red,21,174 normal,bold,normal,bold,bold,bold,bold,bold,bold |
      less -RMFX

}

phist()
{
   local n
   [[ -n $1 ]] && n="-n $1"
   tail $n ~/.persistent_history |
      color_phist
}

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

