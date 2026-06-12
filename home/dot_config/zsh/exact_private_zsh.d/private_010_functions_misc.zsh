#############################################################################
#
# FILE:         010_functions_misc.zsh
#
# DESCRIPTION:  Miscellaneous utility functions
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

# @tags: canbescript
function zshtimes()
{
   [[ -f /tmp/zshtimes.$$ ]] || return 1
   awk '
   {
      if (NR==1) {
         first=$2
      }
      last=$3
      ms = ($3 - $2) * 1000
      printf( "%6.2f ms %s\n", ms, $1)
   }
   END {
      printf("Total: %6.2f ms\n",  (last-first) * 1000 )
   }
   ' /tmp/zshtimes.$$ |

   sort -k1 -n -r
}


#______________________________________________________________________________
# Check whether the argument is a runnable command: shell built-in, alias,
# function, or file in the PATH
#______________________________________________________________________________
#
# @tags: canbescript
function has_command()
{
   (( $+commands[$1] )) || (( $+functions[$1] )) || (( $+aliases[$1] )) || [[ $(whence -w "$1" 2>/dev/null) == *builtin ]]
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

   # Finally run the command with the desired arguments
   "$cmd" "$@"
}
#______________________________________________________________________________


# @tags: command
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
