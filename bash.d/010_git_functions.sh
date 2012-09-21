#!/bin/bash
#############################################################################
#
# FILE:         010_git_functions.sh
#
# DESCRIPTION:  Git related functions and commands (those that have the git-*
#               naming)
#
#############################################################################


##############################################################################
#
# FUNCTION:     git-foldiff
#
# DESCRIPTION:  Show git diff's output in readonly vim, with a closed fold
#               per file.
#
# PARAMETERS:   All parameters will be passed to 'git diff'
#
# ENVIRONMENT:  The VIEW variable can be used to choose the view command or
#               to pass extra options to it. The view command is expected to
#               be some form of vim.
#
# DEPENDS-ON:   git, view, or any command that is pointed by $VIEW
#
##############################################################################
#
git-foldiff()
{
   local view=${VIEW:-view}

   # Pass all arguments to git diff
   git diff "$@" |

      # Add markers to each file entry (this includes a closing mark at the
      # beginning of the file)
      sed -e 's/^\(diff.*\)/# }}}\n\1 {{{/' |

      # Remove that closing mark from the first line
      sed 1d |

      # Pass this all to vim, with instructions to set the markers as
      # the folding method and set the file type to diff (for syntax
      # highlighting if the user has configured vim to do so)
      $view - +'se fdm=marker ft=diff'
}

# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
