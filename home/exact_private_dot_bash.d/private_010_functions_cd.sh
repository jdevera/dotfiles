#!/bin/bash
#############################################################################
#
# FILE:         010_functions_cd.sh
#
# DESCRIPTION:  Functions for changing directories
#
#############################################################################


#______________________________________________________________________________
#
# CD into the parent directory of a file, or to the given path if it already is
# a directory.
#______________________________________________________________________________
#
# @tags: command cd
function cdf()
{
   # shellcheck disable=SC2164
   if [[ -e $1 && ! -d $1 ]]; then
      cd "$(dirname "$1")"
   else
      cd "$1"
   fi
}
#______________________________________________________________________________


# @tags: command cd
function cdz()
{
   local dir
   dir="$(
      awk -F"|" '{printf("%5s\t%s\n", $2, $1);}' "$(__bm_bookmarks_file)"  |
      fzf -1 -0 -x |
      awk -F"\t" '{print $2}'
      )"
   # shellcheck disable=SC2164
   [[ -n $dir ]] && { echo "$dir"; cd "$dir"; }
}

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
