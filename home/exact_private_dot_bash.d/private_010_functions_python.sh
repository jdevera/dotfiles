#!/bin/bash
#############################################################################
#
# FILE:         010_functions_python.sh
#
# DESCRIPTION:  Python and virtualenv related functions
#
#############################################################################


# @tags: command virtualenv
function vecd()
{
   [[ -z $VIRTUAL_ENV ]] && return 1
   # shellcheck disable=SC2164
   cd "$(cat "$VIRTUAL_ENV/.project")"
}

##############################################################################
#
# FUNCTION:     activate-venv
#
# DESCRIPTION:  Activate a Python virtual environment by searching for a .venv
#               directory starting from the current directory and traversing
#               up the directory tree. Stops searching at the git repository
#               root (if in a repo) or the filesystem root.
#
# PARAMETERS:   -h, --help: Show usage information
#
# DEPENDS-ON:   echoe
#
##############################################################################
# @tags: command virtualenv
function activate-venv()
{
   if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      cat <<'EOF'
Usage: activate-venv

Activate a Python virtual environment by searching for a .venv directory.

Searches from the current directory upward until:
  - A .venv directory is found (activates it)
  - A .git directory is found (stops at git root)
  - The filesystem root is reached

On success, prints the path of the activated virtualenv.
On failure, prints an error to stderr and returns 1.
EOF
      return 0
   fi

   local dir="$PWD"

   while [[ "$dir" != "/" ]]; do
      # Check for .venv in current directory
      if [[ -d "$dir/.venv" ]]; then
         echo "Activating: $dir/.venv"
         # shellcheck disable=SC1091
         source "$dir/.venv/bin/activate"
         return 0
      fi

      # Stop at git root
      if [[ -d "$dir/.git" ]]; then
         break
      fi

      # Move up one directory
      dir="$(dirname "$dir")"
   done

   echoe "No .venv found (searched up to git root or /)"
   return 1
}

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
