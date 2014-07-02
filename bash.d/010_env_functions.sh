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
#______________________________________________________________________________
#
addtopath()
{
    local a_directory="$1"
    local a_position="$2"

    a_directory="${a_directory/%\//}"  # remove trailing slash

    # Add only existing directories
    [[ ! -d $a_directory ]] && return 1

    # If the directory is already in the path, remove it so that
    # it can be inserted in the desired position without
    # poluting $PATH with duplicates
    local newpath=`echo $PATH | myrmlistitems "$a_directory" ':'`

    if [[ $a_position == beg ]]; then    # Prefix to $PATH
        export PATH="$a_directory:$newpath"
    elif [[ $a_position == end ]]; then  # Append to $PATH
        export PATH="$newpath:$a_directory"
    else
        return 1
    fi

    return 0
}
#______________________________________________________________________________


#______________________________________________________________________________
# Convenience wrappers for addtopath
#
pathappend()  { addtopath $1 end; return $?; }
pathprepend() { addtopath $1 beg; return $?; }
#______________________________________________________________________________




#______________________________________________________________________________
#
# FUNCTION:     delfrompath
#
# DESCRIPTION:  Delete a directory from the $PATH enviroment variable.
#
# PARAMETERS:   1 (r): Directory to delete
#
# DEPENDS-ON:   myrmlistitems
#______________________________________________________________________________
#
delfrompath()
{
    local a_directory="$1"

    export PATH=`echo $PATH | myrmlistitems "$a_directory" ':'`
}
#______________________________________________________________________________


#______________________________________________________________________________
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
#______________________________________________________________________________
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
#______________________________________________________________________________


#______________________________________________________________________________
#
# FUNCTION:     link_complete_function
#
# DESCRIPTION:  Assign a function called __complete_<blah> to a command named
#               <blah>. The name of the command is a parameter.
#
# PARAMETERS:   1 (r): The name of the command that is used to derive the
#                      completion function name
#               2 (o): Optionally, bind the derived name to this command. This
#                      is used to prevent having to duplicate the function if
#                      it is to be applied to several aliases of the same
#                      command.
#
# HELP:
#     For example, to apply a custom completion function for a `foo` command
#     and its alias `bar`:
#
#        link_complete_function foo
#
#     will use __complete_foo to complete foo, and
#
#        link_complete_function foo bar
#
#     will use also __complete_foo to complete bar
#______________________________________________________________________________
#
function link_complete_function()
{
   eval "complete -C __complete_$1 -o default ${2:-$1}"
}
#______________________________________________________________________________


#______________________________________________________________________________
#
# FUNCTION:     showenv
#
# DESCRIPTION:  Show a pretty printed list of environment variables.
#
# PARAMETERS:   None
#______________________________________________________________________________
#
function showenv()
{
   printenv | grep = | showaliases -a -
}
#______________________________________________________________________________


#______________________________________________________________________________
#
# FUNCTION:     reloadsh
#
# DESCRIPTION:  Reload all bash's config files after clearing all defined
#               functions.
#
# PARAMETERS:   None
#______________________________________________________________________________
#
function reloadsh()
{
   for f in $(declare -F |  awk '{ print $3 }')
   do
      unset -f $f
   done
   unalias -a
   KEEP_PROMPT=1 source $HOME/.bashrc
}
#______________________________________________________________________________

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :

