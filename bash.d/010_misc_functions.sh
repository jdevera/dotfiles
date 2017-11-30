#!/bin/bash
#############################################################################
#
# FILE:         020_misc_functions.sh
#
# DESCRIPTION:  
#
#############################################################################

# @tags: support
function show_parent_dirs()
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

# @tags: command canbescript
function stripe()
{
   perl -pe '$_ = "\033[1;34m$_\033[0m" if($. % 2)'
}

# @tags: command canbescript
function stripcolor()
{
   sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" "$@"
}

# @tags: command wrapper
function check_home_purity()
{
   [ -z "$PS1" ] && return
   purehome
}

# @tags: support
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


# @tags: command canbescript
function hl()
{
   pygmentize -g -f terminal256 -P style=emacs "$@"
}

# @tags: command canbescript
function hless()
{
   hl "$@" | less -FiXRM
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
# @tags: command
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
# @tags: command canbescript
function xf()
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
# @tags: command cd
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
# @tags: command canbescript
function whed()
{
   if [[ $(builtin type -t $1) == 'function' ]]
   then
      whedf $1
      return
   fi
   local matches="$(which -a "$@" | fzf -0 -1 --multi)"
   if [[ -z $matches ]]
   then
      echo "No matches found for $@" 1>&2
      return 1
   fi
   $EDITOR "$matches"
}
complete -c whed # Complete with command names

function whedf()
{
   local match="$(find_function $1 | awk '{ printf("%s +%d\n", $3, $2) }')"
   if [[ -z $match ]]
   then
      echo "No match found for function $@" 1>&2
      return 1
   fi
   $EDITOR $match

}
#______________________________________________________________________________


#______________________________________________________________________________
#
# A powerful version of touch. Create all the path until it can touch the file.
#______________________________________________________________________________
#
# @tags: command canbescript
function rtouch()
{
   local path="$1"
   mkdir -p "$(dirname $path)"
   touch "$path"
}
#______________________________________________________________________________


#______________________________________________________________________________
# Runs locate with all given arguments, and uses the fzf fuzzy finder to choose
# from the results one file to open in the configured $EDITOR
#______________________________________________________________________________
#
# @tags: command canbescript
function eloc()
{
   local file="$(locate "$@" | fzf -0 -1 -x)"
   if [[ -n $file ]]
   then
      $EDITOR "$file"
   fi
}
#______________________________________________________________________________


#______________________________________________________________________________
# Show the most recently downloaded files. With colours!
#______________________________________________________________________________
#
# @tags: command canbescript
function lastdown()
{
   find $DDOWN -maxdepth 1 -printf '%T@ %TY-%Tm-%Td %TT %p\n'  |
      sort -k1 -n |
      cut -d' ' -f2- |
      cut -c-19,31- |
      grep -v $DDOWN$ |
      colout '^(\S+ \S+) ('$DDOWN'/)(.+)$' blue,black,cyan dim,dim,dim |
      tail "$@"
}
#______________________________________________________________________________


#______________________________________________________________________________
# Check whether the argument is a runnable command: shell built-in, alias,
# function, or file in the PATH
#______________________________________________________________________________
#
# @tags: support
function has_command()
{
   type "$1" >& /dev/null
}
#______________________________________________________________________________


#______________________________________________________________________________
# run_first_of COMMAND_LIST [-- ARGUMENTS]
#
# Run the first command from COMMAND_LIST that is found to exist.
# When -- is found after the command list, it is discarded and all subsequent
# arguments are passed directly to the command that is found first, if any.
#______________________________________________________________________________
#
# @tags: support
function run_first_of()
{
   local cmd=
   # Find the command
   while [[ $# -gt 0 ]]
   do
      # If we find -- before finding the command, none of the commands listed
      # actually exist, so bail out
      [[ $1 == '--' ]] && return 1

      if has_command "$1"; then
         cmd="$1"
         shift
         break
      fi
      shift
   done

   [[ -z $cmd ]] && return 1

   # A command was found, now discard the rest of the commands and '--' if
   # found, so that we are left with the list of arguments to pass to the
   # command.
   while [[ $# -gt 0 ]]
   do
      if [[ $1 == '--' ]]; then
         shift
         break
      fi
      shift
   done

   # Finaly run the command with the desired arguments
   "$cmd" "$@"
}
#______________________________________________________________________________


# @tags: command canbescript filter
function ranking()
{
   local rev='-r'
   if [[ $1 == '-r' ]]
   then
      rev=''
      shift
   fi
   sort "$@" | uniq -c | sort -k 1 -n $rev
}

# @tags: command cd
function cdz()
{
   local dir="$(
      awk -F"|" '{printf("%5s\t%s\n", $2, $1);}' "$(__bm_bookmarks_file)"  |
      fzf -1 -0 -x |
      awk -F"\t" '{print $2}'
      )"
   [[ -n $dir ]] && { echo $dir; cd "$dir"; }
}


# @tags: command virtualenv
function vecd()
{
   [[ -z $VIRTUAL_ENV ]] && return 1
   cd "$(cat "$VIRTUAL_ENV/.project")"
}

# tags: network command
function getfavicon()
{
   local url="$1/favicon.ico"
   local name="$2"
   if [[ -z $name ]]; then
      name="$(python -c 'import sys,urlparse; print urlparse.urlparse(sys.argv[1]).netloc.replace(".", "_")' "$1")"
   fi
   local favdir="$DDOWN/favicons"
   mkdir -p "$favdir"
   DDOWN="$favdir" download "$url" && mv "$favdir/favicon.ico" "$favdir/${name}.ico"
}


# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

