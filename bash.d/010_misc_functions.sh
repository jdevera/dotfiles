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
   local diff=$( diff --suppress-common-lines -wB \
      <( ls ~ | sort) \
      <( echo -e "backup\ncomms\ndevel\ndoc\nmedia\nother") \
      )
   [[ -z $diff ]] && return 0
   local rubbish=$(echo "$diff" | grep '^<' | cut -c 3-)
   local missing=$(echo "$diff" | grep '^>' | cut -c 3-)
   [[ -z $rubbish ]] && [[ -z $missing ]] || echo "You home is not pure!"
   [[ -n $missing ]] && echo " * Missing:" $missing
   [[ -n $rubbish ]] && echo " * Superfluous:" $rubbish
}

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

