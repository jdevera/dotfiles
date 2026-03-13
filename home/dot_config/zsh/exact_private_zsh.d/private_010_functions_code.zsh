#############################################################################
#
# FILE:         010_functions_code.zsh
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
   local func="$1"
   local highlighter
   if has_command bat; then
      highlighter="bat -l bash --style=plain"
   elif has_command pygmentize; then
      highlighter="hless -l sh"
   else
      highlighter="less -r"
   fi
   functions "$func" | eval $highlighter
}

# @tags: canbescript
# DEPENDS-ON: has_command, hless
function _code_show_script()
{
   local filepath="$1"
   if has_command bat; then
      bat "$filepath"
   elif has_command pygmentize; then
      hless "$filepath"
   else
      less -Fr "$filepath"
   fi
}

# @tags: command canbescript
# DEPENDS-ON: find_function, _code_show_function, _code_show_script
function showme()
{
   local wtype
   wtype="$(whence -w "$1" 2>/dev/null | awk '{print $2}')"
   case $wtype in
      alias)
         echo "$1 is an alias"
         alias "$1"
         ;;
      function)
         echo "$1 is a function"
         local location
         location="$(find_function "$1")"
         if [[ -n $location ]]; then
            local func line filepath
            read -r func line filepath <<< "$location"
            printf "Defined in: %s +%d\n" "$filepath" "$line"
         fi
         _code_show_function "$1"
         ;;
      builtin | reserved)
         echo "$1 is a shell $wtype"
         # ZSH has no builtin help; use run-help
         man zshbuiltins 2>/dev/null | less -p "^       $1 " || echo "No help available for $1"
         ;;
      command)
         local filepath
         filepath="$(whence -p "$1")"
         if head -1 "$filepath" | grep -q "^#!"; then
            echo "$1 is a script at $filepath"
            _code_show_script "$filepath"
         else
            echo "$1 is a binary at $filepath"
         fi
         ;;
      *)
         echo "I don't know what $1 is"
         return 1
         ;;
   esac
}
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
   if [[ $(whence -w "$1" 2>/dev/null | awk '{print $2}') == 'function' ]]
   then
      whedf "$1"
      return
   fi
   local matches
   matches="$(whence -pa "$@" | fzf -0 -1 --multi)"
   if [[ -z $matches ]]
   then
      echoe "No matches found for $*"
      return 1
   fi
   $EDITOR "$matches"
}

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
