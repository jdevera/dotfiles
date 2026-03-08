#############################################################################
#
# FILE:         010_functions_env.zsh
#
# DESCRIPTION:  Environment and PATH manipulation functions
#
#############################################################################



##############################################################################
#
# FUNCTION:     addtopath
#
# DESCRIPTION:  Add a directory to the $PATH environment variable.
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
function addtopath()
{
    local a_directory="$1"
    local a_position="$2"

    a_directory="${a_directory/%\//}"  # remove trailing slash

    # Add only existing directories
    [[ ! -d $a_directory ]] && return 1

    # If the directory is already in the path, remove it so that
    # it can be inserted in the desired position without
    # polluting $PATH with duplicates
    local newpath
    newpath=$(echo "$PATH" | myrmlistitems "$a_directory" ':')

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
# @tags: command
function pathappend()  { addtopath "$1" end; }
# @tags: command
function pathprepend() { addtopath "$1" beg; }
#______________________________________________________________________________



#______________________________________________________________________________
#
# FUNCTION:     delfrompath
#
# DESCRIPTION:  Delete a directory from the $PATH environment variable.
#
# PARAMETERS:   1 (r): Directory to delete
#
# DEPENDS-ON:   myrmlistitems
#______________________________________________________________________________
#
# @tags: command
function delfrompath()
{
    local a_directory=$1

    PATH=$(echo "$PATH" | myrmlistitems "$a_directory" ':')
    export PATH
}
#______________________________________________________________________________


#______________________________________________________________________________
#
# FUNCTION:     link_complete_function
#
# DESCRIPTION:  Assign a completion function to a command. In ZSH, this uses
#               compdef to bind completion functions.
#
# PARAMETERS:   1 (r): The name of the command
#               2 (o): Optionally, bind the same completion to this command
#______________________________________________________________________________
#
# DEPENDS-ON: has_command, function_exists
function link_complete_function()
{
   local command=$1
   local target=${2:-$1}
   if has_command fzf && (( $+functions[__fzf_complete_$command] )); then
      compdef "__fzf_complete_$command" "$target"
   elif (( $+functions[__complete_$command] )); then
      compdef "__complete_$command" "$target"
   fi
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
# @tags: command canbescript
# DEPENDS-ON: showaliases
function showenv()
{
   printenv | grep '=' | showaliases -a -
}
#______________________________________________________________________________


#______________________________________________________________________________
#
# FUNCTION:     reloadsh
#
# DESCRIPTION:  Reload all ZSH config files after clearing all defined
#               functions.
#
# PARAMETERS:   None
#______________________________________________________________________________
#
# @tags: command
# DEPENDS-ON: is_login_shell
function reloadsh()
{
   local option=
   is_login_shell && option=-l
   exec zsh $option
}
#______________________________________________________________________________


#______________________________________________________________________________
#
# env-save and env-load are written to work with long lived tmux sessions. When
# attaching to an existing session, some elements of the outer environment,
# such as the DISPLAY, might have changed. These help taking care of that.
#
# Run env-save outside of tmux and then env-load inside.
#______________________________________________________________________________
# @tags: command canbescript
function env-save()
{
   export |
      grep 'SSH_AUTH_SOCK\|GNOME_KEYRING\|DISPLAY' |
      grep -v PERSISTENT_HISTORY_LAST \
      > "/tmp/${USER}.env"
}

# @tags: command
function env-load()
{
   source "/tmp/${USER}.env"
}
#______________________________________________________________________________

function __ensure_path_stack()
{
   if ! (( ${+PATH_STACK} )); then
      typeset -ga PATH_STACK
      PATH_STACK=()
   fi
}
# @tags: command
# DEPENDS-ON: __ensure_path_stack
function push-path()
{
   __ensure_path_stack
   PATH_STACK+=("$PATH")
   echo "Pushed PATH: $PATH"
}

# @tags: command
# DEPENDS-ON: __ensure_path_stack, echoe
function pop-path()
{
   __ensure_path_stack
   local size=${#PATH_STACK[@]}
   if [[ $size -eq 0 ]]
   then
      echoe 'PATH stack is empty, could not pop.'
      return 1
   fi
   local last_elem=${PATH_STACK[-1]}
   PATH=$last_elem
   echo "Popped PATH: $PATH"
   PATH_STACK[-1]=()
}


# @tags: canbescript
function is_login_shell()
{
   [[ -o login ]]
}
