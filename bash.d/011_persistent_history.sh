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

   # Off the record entries if PHIST_OFF_RECORD is loaded {{{
   # # Commented out for speed
   # if [[ ${PHIST_OFF_RECORD:-0} -ne 0 ]]; then
   #    unset PHIST_METADATA
   #    return
   # fi

   # }}}
   # Save the values of $? and $PIPESTATUS: {{{
   local LAST_RC=${LAST_RC:-$?}
   local LAST_PIPESTATUS=(${LAST_PIPESTATUS[@]:-${PIPESTATUS[@]}})
   # echo PIPESTATUS ${PIPESTATUS[@]}
   # echo LAST_PIPESTATUS ${LAST_PIPESTATUS[@]}

   # }}}
   # Set the history time format to one we can use in the future {{{
   local HISTTIMEFORMAT="%Y-%m-%d %T %z "

   # }}}
   # Capture the last command and date time {{{
   [[
      $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+\ [^\ ]+)\ +(.*)$
   ]]
   local date_part="${BASH_REMATCH[1]}"
   local command_part="${BASH_REMATCH[2]}"

   # }}}
   # Prevent repetition if $PHIST_SAVE_DUPS is set to 0 {{{
   if [[ ${PHIST_SAVE_DUPS:-1} -eq 0 ]] && [[ $command_part == "$PERSISTENT_HISTORY_LAST" ]]
   then
      unset PHIST_METADATA
      return
   fi

   # }}}
   if ! has_command rsh-store
   then
      # Write directly to Classic text file for Rich Shell History {{{
      :
      # local DELIM='|'
      # echo "$date_part $DELIM $PWD $DELIM $LAST_RC $DELIM $command_part" >> ~/.persistent_history
      # }}}
   else
      # Use rsh-store to save to JSON and Text files {{{

      # PHIST_METADATA is an associative array that might already contain metadata
      # key value pairs. Redeclaring will not overwrite.
      declare -gA PHIST_METADATA

      local metadata=()
      local metakey metavalue
      for metakey in "${!PHIST_METADATA[@]}"
      do
         metavalue="${PHIST_METADATA[$metakey]}"
         metadata=( "${metadata[@]}" '--metadata' "${metakey}=${metavalue}" )
      done
      rsh-store \
               "${metadata[@]}"         \
               "$command_part"          \
               "$date_part"             \
               "$PWD"                   \
               "$$"                     \
               "$LAST_RC"               \
               "${#LAST_PIPESTATUS[@]}" \
               "${LAST_PIPESTATUS[@]}"  \
               --json-output ~/.persistent_history.json \
               --text-output ~/.persistent_history
      # }}}
   fi

   export PERSISTENT_HISTORY_LAST="$command_part"
   unset PHIST_METADATA
}
# A better named transparent wrapper
log_bash_rich_history()
{
   log_bash_persistent_history "$@"
}


persistent_history_add_metadata()
{
   declare -gA PHIST_METADATA
   PHIST_METADATA["$1"]="$2"
}
# A better named transparent wrapper:
bash_rich_history_add_metadata()
{
   persistent_history_add_metadata "$@"
}


# Rich History Search
rhs()
{
   run_first_of ag rg ack grep -- "$@" ~/.persistent_history
}

rhist()
{
   local n
   [[ -n $1 ]] && n="-n $1"
   tail "$n" ~/.persistent_history |
      color_rhist
}

color_rhist()
{
   colout '^([^\|]+)(\|)([^|]+)(\|) (?:(\?)|(0)|([1-9]\d*)) (\|)(.*)$' \
      208,21,238,21,yellow,green,red,21,174 \
      normal,bold,normal,bold,bold,bold,bold,bold,bold |
      less -RMFX
}


# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

