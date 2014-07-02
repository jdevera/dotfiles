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


hless()
{
   pygmentize -g -f terminal256 -P style=emacs "$@" | less -FiXRM
}


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
function code()
{
   local type="$(builtin type -t $1)"
   case $type in
      alias)
         echo "$1 is an alias"
         builtin alias "$1" | sed 's/^[^=]\+=//'
         ;;
      function)
         echo "$1 is a function"
         find_function $1 | awk '{ printf("Defined in: %s +%d\n", $3, $2) }'
         builtin declare -f "$1" | hless
         ;;
      builtin | keyword)
         echo "$1 is a shell $type"
         builtin help "$1"
         ;;
      file)
         local path="$(which "$1")"
         if head -1 "$path" | grep -q "^#!"; then
            echo "$1 is a script at $path"
            cat "$path" | hless
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
# Unified way of extracting compressed files.
#______________________________________________________________________________
#
function extract()
{
   local file="$1"
   [[ -f $1 ]] || { echo "$file not a file" >&2; return 1; }
   case $file in
      *.tar.bz2 ) tar xjf    "$file"  ;;
      *.tar.gz  ) tar xzf    "$file"  ;;
      *.bz2     ) bunzip2    "$file"  ;;
      *.rar     ) rar x      "$file"  ;;
      *.gz      ) gunzip     "$file"  ;;
      *.tar     ) tar xf     "$file"  ;;
      *.tbz2    ) tar xjf    "$file"  ;;
      *.tgz     ) tar xzf    "$file"  ;;
      *.zip     ) unzip      "$file"  ;;
      *.Z       ) uncompress "$file"  ;;
      *.7z      ) 7z x       "$file"  ;;
      *         )
         echo "Don't know how to extract '$file'" >&2
         return 1
         ;;
    esac
}
#______________________________________________________________________________


#______________________________________________________________________________
#
# CD into the parent directory of a file, or to the given path if it already is
# a directory.
#______________________________________________________________________________
#
function cdf()
{
   if [[ -e $1 && ! -d $1 ]]; then
      cd "$(dirname "$1")"
   else
      cd "$1"
   fi
}
#______________________________________________________________________________


#______________________________________________________________________________
#
# which + editor = whed
#______________________________________________________________________________
#
function whed()
{
   local matches="$(which -a "$@" | fzf -0 -1)"
   if [[ -z $matches ]]
   then
      echo "No matches found for $@" 1>&2
      return 1
   fi
   $EDITOR "$matches"
}
complete -c whed # Complete with command names
#______________________________________________________________________________


#______________________________________________________________________________
#
# A powerful version of touch. Create all the path until it can touch the file.
#______________________________________________________________________________
#
function rtouch()
{
   local path="$1"
   mkdir -p "$(dirname $path)"
   touch "$path"
}
#______________________________________________________________________________


# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

