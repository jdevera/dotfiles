#!/bin/bash
#############################################################################
#
# FILE:         010_function_functions.sh
#
# DESCRIPTION:  Functions to handle bash functions
#
#############################################################################



# Check if a function given by name is defined in the current shell instance
function_exists()
{
   local a_function_name="$1"

   [[ -z $a_function_name ]] && return 1

   declare -F "$a_function_name" > /dev/null 2>&1

   return $?
}

# If the function specified in the first parameter exists, call it with the
# subsequent parameters
function call_if()
{
   function_exists "$1" && "$@"
}

# Find the location where a function has been defined
function find_function()
{
   ( shopt -s extdebug; declare -F $1 )
}

# Output the names of all functions defined in the current shell
function dump_functions()
{
   declare -f $(declare -F | awk '{print $3}')
}

# Show a pretty printed of shell functions, sorted by file and line
function list_functions()
{
   # Get the functions with the origin files and lines
   (
   shopt -s extdebug
   for f in $(declare -F | awk '{ print $3 }' )
   do
      declare -F $f
   done
   ) |

   # Filter out bash_completion functions, there are too many
   grep -v bash_completion |

   # Sort by file first and then by line
   sort -k3 -k2.1n |

   # Format grouped by file
   awk 'BEGIN{
      prev = 0
   }
   {
      if (prev != $3) {
         print "\n" $3
         prev = $3
      }
      printf("%4s\t%s\n", $2, $1)
   }' |

   # Colorize titles (filename)
   colout '^/.*' cyan
}


# List all defined functions in a format that can be easily viewed in vim
function __list_functions()
{
   # Get the functions with the origin files and lines
   (
   shopt -s extdebug
   for f in $(declare -F | awk '{ print $3 }' )
   do
      declare -F $f
   done
   ) |

   # Filter out bash_completion functions, there are too many
   grep -v bash_completion |

   # Sort by file first and then by line
   sort -k3 -k2.1n |

   # Format grouped by file
   awk 'BEGIN{
      prev = 0
   }
   {
      function_name = $1
      lineno=$2
      file=$3
      if (prev != file) {
         if (prev != 0) {
            print "echo \"# }" "}}\""
         }
         printf("echo \"# FILE: %s {{" "{\"\n", file)
         prev = file
      }
      printf("echo \"## FUNCTION: %s (line %s) {{" "{\"\n", function_name, lineno)
      print "echo \"$(declare -f " function_name ")\""
      print "echo \"# }" "}}\""
   }
   END{
      print "echo \"# }" "}}\""
   }' |

   # Colorize titles (filename)
   colout '^/.*' cyan
}


# View all defined functions in vim
function viewfuncs()
{
   eval "$(__list_functions)" | view - +'se ft=sh fdm=marker'
}

# vim: ft=sh fdm=marker expandtab ts=4 sw=4 :

