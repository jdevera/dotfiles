#############################################################################
#
# FILE:         010_functions_git.zsh
#
# DESCRIPTION:  Git related functions and commands
#
#############################################################################



# @tags: command cd
# DEPENDS-ON: run_first_of, hless, hl
function git-explore()
{
    local dest
    dest="/tmp/git/$(basename "$1" .git)"
    while [[ -e $dest ]]
    do
       dest=${dest}_
    done

    run_first_of hub git -- clone --depth=1 --recursive "$1" "$dest" &&
        cd "$dest" ||
        return 1

    local readme=
    for readme in ./README*(N)
    do
       break
    done
    [[ -e $readme ]] && run_first_of bat hless hl view less -- "$readme"
}

# @tags: canbescript
function in_git_repo()
{
   git rev-parse &> /dev/null
}
