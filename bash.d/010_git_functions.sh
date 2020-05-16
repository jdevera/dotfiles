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



function git-explore()
{
    local dest="/tmp/git/$(basename $1 .git)"
    while [[ -e $dest ]]
    do
       dest=${dest}_
    done

    run_first_of hub git -- clone --depth=1 --recursive $1 $dest && cd "$dest" || return 1

    local readme=
    for readme in ./README*
    do
       break
    done
    [[ -e $readme ]] && run_first_of hless hl view less -- $readme
}

function in_git_repo()
{
   git rev-parse &> /dev/null
}

function check_in_git_repo()
{
   if ! in_git_repo
   then
      echo "Not in a git repository" &>2
      return 1
   fi
   return 0
}


function git_has_local_branch()
{
   check_in_git_repo || return 1
   git show-ref --verify --quiet refs/heads/$1
}


function __newbranch_colorise()
{
    local color=$1
    shift
    echo $(ansi_color $color)$*$(ansi_color none)
}

function newbranch()
{
    local branch="$1"
    [[ -n $branch ]] || return 1
    local upstream="$(git upstream)"
    local starting_branch=$(command git rev-parse --abbrev-ref HEAD)
    command git checkout -b "$branch"
    [[ -z $upstream ]] && return 0
    command git branch --set-upstream-to="$upstream" HEAD

    echo -en "\nNew branch $(__newbranch_colorise light_cyan "$branch") starting in "
    echo -en "$(__newbranch_colorise light_purple "$starting_branch") with upstream set to "
    echo -en "$(__newbranch_colorise light_green "$upstream")\n\n"
}

function __jirabranch_getbranchname()
{
    local issue=$1
    local issuetitle="$(cut -d'	' -f5 <<< "$issue" | slugify --separator ' ' --stdin)"
    local prompt="$(cat <<EOP
NEW BRANCH for $issue
    Enter a name for the new branch.
    (spaces will be converted to underscores)
Name >
EOP
)"
    read -p "$prompt " -e -i "$issuetitle" || return 1
    local branch="$(awk '{print $1}' <<< "$issue")-${REPLY// /_}"
    echo $branch
}


function jirabranch()
{
    local issue=$(jiralist --no-color --porcelain | fzf -0 -1)
    local branch=$(__jirabranch_getbranchname "$issue")
    newbranch "$branch"
}
# vim: ft=sh fdm=marker expandtab ts=3 sw=3 :
