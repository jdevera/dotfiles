#!/bin/bash
#############################################################################
#
# FILE:         030_env_functions.sh
#
# DESCRIPTION:  
#
#############################################################################




##############################################################################
#
# FUNCTION:     addtopath
#
# DESCRIPTION:  Add a directory to the $PATH enviroment variable.
#               - Checks that the directory exists.
#               - Directories can be inserted at the beginning or the end of
#                 the $PATH.
#               - If the directory is already in the $PATH, it will be moved
#                 to the requested position.
#
# PARAMETERS:   1 (r): Directory that is to be inserted in $PATH
#               2 (r): Position for insertion, accepted values are:
#                      - "beg" to insert at the beginning
#                      - "end" to insert at the end
#
# DEPENDS-ON:   myrmlistitems
#
##############################################################################
#
addtopath()
{
    local a_directory="$1"
    local a_position="$2"

    local a_directory=`echo "$a_directory" | sed 's#/$##'`  # remove trailing slash

    # Add only existing directories
    [[ ! -d $a_directory ]] && return 1

    # If the directory is already in the path, remove it so that
    # it can be inserted in the desired position without
    # poluting $PATH with duplicates
    local newpath=`echo $PATH | myrmlistitems "$a_directory" ':'`

    if [[ $a_position == beg ]]; then    # Prefix to $PATH
        export PATH=$a_directory:$newpath
    elif [[ $a_position == end ]]; then  # Append to $PATH
        export PATH=$newpath:$a_directory
    else
        return 1
    fi

    return 0
}

##############################################################################


##############################################################################
# Convenience wrappers for addtopath
#
pathappend()  { addtopath $1 end; return $?; }
pathprepend() { addtopath $1 beg; return $?; }
#
##############################################################################




##############################################################################
#
# FUNCTION:     delfrompath
#
# DESCRIPTION:  Delete a directory from the $PATH enviroment variable.
#
# PARAMETERS:   1 (r): Directory to delete
#
# DEPENDS-ON:   myrmlistitems
#
##############################################################################
#
delfrompath()
{
    local a_directory="$1"

    export PATH=`echo $PATH | myrmlistitems "$a_directory" ':'`
}
##############################################################################


#_____________________________________________________________________________
#
# FUNCTION:     make_completion_wrapper
#
# DESCRIPTION:  Create a completion function for an alias by wrapping the
#               completion function for the original command.
#
# PARAMETERS:   1 (r): Actual completion function
#               2 (r): Name of the new generated function
#               3 (r): Name of the alias
#               4 (r): Original command name
#             5.. (r): List of arguments fixed by the alias
#
# HELP:
#     http://ubuntuforums.org/showthread.php?t=733397
#     For example, to define a function called _apt_get_install that will
#     complete the 'agi' alias:
#        alias agi='apt-get install'
#        make_completion_wrapper _apt_get _apt_get_install agi apt-get install
#        complete -F _apt_get_install agi
#
#_____________________________________________________________________________
#
function make_completion_wrapper ()
{
   local comp_function_name="$1"
   local function_name="$2"
   local alias_name="$3"
   local arg_count=$(($#-4))
   shift 3
   local args="$*"
   local function="
function $function_name {
   COMP_LINE=\"$@\${COMP_LINE#$alias_name}\"
   let COMP_POINT+=$((${#args}-${#alias_name}))
   ((COMP_CWORD+=$arg_count))
   COMP_WORDS=("$@" \"\${COMP_WORDS[@]:1}\")

   local cur words cword prev
   _get_comp_words_by_ref -n =: cur words cword prev
   "$comp_function_name"
   return 0
}"
   eval "$function"
}


function link_complete_function()
{
   eval "complete -C __complete_$1 -o default ${2:-$1}"
}

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

