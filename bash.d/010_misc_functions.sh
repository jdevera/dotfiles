#!/bin/bash
#############################################################################
#
# FILE:         020_misc_functions.sh
#
# DESCRIPTION:  
#
#############################################################################

show_parent_dirs()
{
   pwd | awk '
   BEGIN {
      MAXLEVEL=5;
   }
   {
      levels = gsub(/\//,"/");
      for (i = 1; i <= levels && i <= MAXLEVEL; i++)
      {
         gsub(/\/[^\/]+$/,"");  # delete one level
         (i == levels) && $1="/";
         printf("..%s\t%s\n", (i != 1) ? i : "" , $0);
      }
   }'
}


function_exists()
{
   local a_function_name="$1"

   [[ -z $a_function_name ]] && return 1

   declare -F "$a_function_name" > /dev/null 2>&1

   return $?
}

function call_if()
{
   function_exists "$1" && "$1"
}

stripe()
{
   perl -pe '$_ = "\033[1;34m$_\033[0m" if($. % 2)'
}

function check_home_purity()
{
   [ -z "$PS1" ] && return
   purehome
}

function bashtimes()
{
   [[ -f /tmp/bashtimes.$$ ]] || return 1
   awk '
   {
      if (NR==1) {
         first=$2
      }
      last=$3
      ms = ($3 - $2) / 1000000
      printf( "%6.2f ms %s\n", ms, $1)
   }
   END {
      printf("Total: %6.2f ms\n",  (last-first) / 1000000 )
   }
   ' /tmp/bashtimes.$$ |

   sort -k1 -n -r
}

function virtualenvwrapper_enable()
{
   VIRTUAL_ENV_WRAPPER="$(which virtualenvwrapper.sh 2>/dev/null)"

   [[ -n $VIRTUAL_ENV_WRAPPER ]] && source "$VIRTUAL_ENV_WRAPPER" > /dev/null
}


# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

