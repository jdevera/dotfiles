#!/bin/bash
#############################################################################
#
# FILE:         010_functions_code.sh
#
# DESCRIPTION:  Functions for viewing and editing code, scripts, and functions
#
#############################################################################


#______________________________________________________________________________
#
# Find the type of executable "thing" that the shell will use and try to
# describe it in its output:
#
# For an alias, print its definition
# For a function, print its code
# For a shell builtin, print its help text
# For a script, print the source
# For a binary executable file, print nothing.
#______________________________________________________________________________
#
# @tags: canbescript
# DEPENDS-ON: has_command, hless
function _code_show_function()
{
   local function="$1"
   local highlighter
   if has_command bat; then
      highlighter="bat -l bash --style=plain"
   elif has_command pygmentize; then
      highlighter="hless -l sh"
   else
      highlighter="less -r"
   fi
   builtin declare -f "$function" | $highlighter
}

# @tags: canbescript
# DEPENDS-ON: has_command, hless
function _code_show_script()
{
   local path="$1"
   if has_command bat; then
      bat "$path"
   elif has_command pygmentize; then
      hless "$path"
   else
      less -Fr "$path"
   fi
}

# @tags: command canbescript
# DEPENDS-ON: find_function, _code_show_function, _code_show_script
function code()
{
   local type
   type="$(builtin type -t "$1")"
   case $type in
      alias)
         echo "$1 is an alias"
         builtin alias "$1" | sed 's/^[^=]\+=//'
         ;;
      function)
         echo "$1 is a function"
         local function line path
         read -r function line path <<< "$(find_function "$1")"
         printf "Defined in: %s +%d\n" "$path" "$line"
         _code_show_function "$function"
         ;;
      builtin | keyword)
         echo "$1 is a shell $type"
         builtin help "$1"
         ;;
      file)
         local path
         path="$(which "$1")"
         if head -1 "$path" | grep -q "^#!"; then
            echo "$1 is a script at $path"
            _code_show_script "$path"
         else
            echo "$1 is a binary at $path"
         fi
         ;;
      *)
         echo "I don't know what $1 is"
         return 1
         ;;
   esac
}
complete -c code # Complete with command names
#______________________________________________________________________________


#______________________________________________________________________________
#
# which + editor = whed
#______________________________________________________________________________
#
# @tags: command canbescript
# DEPENDS-ON: echoe, whedf
function whed()
{
   if [[ $(builtin type -t "$1") == 'function' ]]
   then
      whedf "$1"
      return
   fi
   local matches
   matches="$(which -a "$@" | fzf -0 -1 --multi)"
   if [[ -z $matches ]]
   then
      echoe "No matches found for $*"
      return 1
   fi
   $EDITOR "$matches"
}
complete -c whed # Complete with command names

# @tags: command canbescript
# DEPENDS-ON: echoe, find_function
function whedf()
{
   local match file line
   match=$(find_function "$1")
   if [[ -z $match ]]
   then
      echoe "No match found for function $*"
      return 1
   fi
   file=$(cut -d' ' -f3- <<<"$match")
   line=$(cut -d' ' -f2  <<<"$match")
   $EDITOR "$file" "+$line"
}
#______________________________________________________________________________

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
