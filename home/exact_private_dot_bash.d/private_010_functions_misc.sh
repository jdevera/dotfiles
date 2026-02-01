#!/bin/bash
#############################################################################
#
# FILE:         020_misc_functions.sh
#
# DESCRIPTION:
#
#############################################################################

# @tags: canbescript
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
# DEPENDS-ON: is_osx, assert_has_command
function stripcolor()
{
   local sed=sed
   if is_osx
   then
      assert_has_command gsed
      sed=gsed
   fi

   $sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" "$@"
}

# @tags: canbescript
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
   local style
   style=${HL_STYLE:-emacs}
   local guess_arg='-g'
   local arg
   for arg in "$@"
   do
      if [[ $arg == '-l' ]]
      then
         guess_arg=''
         break
      fi
   done
   pygmentize "$guess_arg" -f terminal256 -P "style=$style" "$@"
}

# @tags: command canbescript
# DEPENDS-ON: hl
function hless()
{
   hl "$@" | less -FiXRM
}

# Choose the style to use for hl and hless
# @tags: command
function hl_style()
{
   local file style newstyle
   file=${1:?Need a file as first argument}
   style=${HL_STYLE:-emacs}
   assert_has_command pygmentize || return  1
   assert_has_command fzf || return  1
   # shellcheck disable=SC2063
   newstyle=$(pygmentize -L styles |
      grep '*' |
      cut -d' ' -f2 |
      sed 's/://' |
      sed "s/$style/$style (current style)/" |
      fzf --preview "pygmentize -g -f terminal256 -P style=\$(echo {}| cut -d ' ' -f1) '$file'")
   if [[ -n $newstyle ]]
   then
      newstyle=$(echo "$newstyle" | cut -d ' ' -f1)
      echo "New style is $newstyle"
      HL_STYLE=$newstyle
   else
      echo "No style chosen, $style remains"
   fi
}


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
      *.tar.xz|*.tar.bz2|*.tar.gz  ) tar xf    "$file"  ;;
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
# A powerful version of touch. Create all the path until it can touch the file.
#______________________________________________________________________________
#
# @tags: command canbescript
function rtouch()
{
   local path="$1"
   mkdir -p "$(dirname "$path")"
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
   local file=
   # shellcheck disable=SC2016
   file=$(locate "$@" |
      fzf --exit-0 -select-1 --extended \
         --preview '[[ -d {} ]] || head -n $LINES {} | less -RMS' \
         --preview-window hidden \
         --bind '?:toggle-preview')
   if [[ -n $file ]]
   then
      $EDITOR "$file"
   fi
}
#______________________________________________________________________________


#______________________________________________________________________________
# Check whether the argument is a runnable command: shell built-in, alias,
# function, or file in the PATH
#______________________________________________________________________________
#
# @tags: canbescript
function has_command()
{
   type "$1" >& /dev/null
}
#______________________________________________________________________________

# @tags: canbescript
# DEPENDS-ON: has_command, echoe
function assert_has_command()
{
   local command
   command=$1
   if ! has_command "$command"
   then
      echoe "Required command '$command' not found in PATH"
      return 1
   fi
}


#______________________________________________________________________________
# run_first_of COMMAND_LIST [-- ARGUMENTS]
#
# Run the first command from COMMAND_LIST that is found to exist.
# When -- is found after the command list, it is discarded and all subsequent
# arguments are passed directly to the command that is found first, if any.
#______________________________________________________________________________
#
# @tags: canbescript
# DEPENDS-ON: has_command
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
   sort "$@" | uniq -c | sort -k 1 -n "$rev"
}


# @tags: command canbescript
# DEPENDS-ON: assert_has_command, has_command
function edot()
{
   local dir
   dir=${1:-~/.dotfiles}
   assert_has_command fzf
   assert_has_command fd

   local preview_command
   if has_command bat
   then
      preview_command="bat --color=always --line-range=:500"
   elif has_command pygmentize
   then
      preview_command="pygmentize -g -f terminal256 -P style=emacs"
   else
      preview_command='less -r'
   fi

   (builtin cd "$dir" && fd -I -tl -tf) |
      fzf \
      --preview "$preview_command '$dir/{}'" \
      --bind "enter:execute($EDITOR '$dir/{}' </dev/tty)"
}


# @tags: command canbescript
function run_until_fail()
{
   local -i times=0
   while true
   do
      (( times += 1 ))
      echo "---------------------------------------------------"
      echo "RUNNING UNTIL FAILURE (iteration $times)"
      echo "Command: $*"
      echo "---------------------------------------------------"
      "$@" || break
   done
   echo "FAILED in iteration $times"
}


# This is a very hacky way to unset a readonly variable. With GDB!
# @tags: command
function unset_readonly_var()
{
   local var=$1
   cat << EOF| sudo gdb
attach $$
call unbind_variable("$var")
detach
EOF

}


# @tags: command canbescript
function abspath()
{
   python3 -c 'import os, sys; [print(os.path.abspath(path)) for path in sys.argv[1:]]' "$@"
}


# @tags: command canbescript
function ppm()  # Poor Person's man
{
   local command=$1
   $command --help | less
}

# @tags: command canbescript
# DEPENDS-ON: assert_has_command, edot
function vispanso() {
   assert_has_command espanso && edot "$(espanso path config)"
}

# @tags: command canbescript
# DEPENDS-ON: vispanso
function espanso-cfg() {
   vispanso
}

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
