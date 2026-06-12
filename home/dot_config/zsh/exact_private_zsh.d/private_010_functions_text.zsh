#############################################################################
#
# FILE:         010_functions_text.zsh
#
# DESCRIPTION:  Text processing functions
#
#############################################################################



#*****************************************************************************
#
# FUNCTION:     mysplit
#
# DESCRIPTION:  Split a string, printing each slice in its own line
#
# PARAMETERS:   1 (o): Delimiter string
#               2 (o): Input file name; will use standard input if none
#                      is provided.
#
# DEPENDS-ON:   None
#
##############################################################################
#
# @tags: canbescript filter
function mysplit()
{
    local default_delimiter=" "

    local a_delimiter="${1:-$default_delimiter}"
    local a_inputfile="$2"

    awk -F "$a_delimiter" \
    '{  for(i = 1; i <= NF; i++) {
            print $i
        }
    }' "$a_inputfile"
}
##############################################################################




##############################################################################
#
# FUNCTION:     myjoin
#
# DESCRIPTION:  Join several lines in one using a custom delimiter.
#
# PARAMETERS:   1 (o): Delimiter string
#               2 (o): Input file name; will use standard input if none
#                      is provided.
#
# DEPENDS-ON:   None
#
##############################################################################
#
# @tags: canbescript filter
function myjoin()
{
    local default_delimiter=" "

    local a_delimiter="${1:-$default_delimiter}"
    local a_inputfile="$2"

	awk -v usersep="$a_delimiter" '
	BEGIN{
		sep=""; # Start with no separator (before the first item)
	}
	{
		printf("%s%s", sep, $0);
		(NR == 1) && sep = usersep; # Separator is set after the first item.
	}
	END{
		print "" # Print a new line at the end.
	}' "$a_inputfile"
}
##############################################################################




##############################################################################
#
# FUNCTION:     myrmlistitems
#
# DESCRIPTION:  Remove all appearances of a field from a delimited list,
#               making sure that delimiters are consistent afterward.
#
# PARAMETERS:   1 (r): Element to be removed
#               2 (o): Delimiter string
#               3 (o): Input file name; will use standard input if none
#                      is provided.
#
# DEPENDS-ON:   mysplit myjoin
##############################################################################
#
# @tags: canbescript filter
function myrmlistitems()
{
    local default_delimiter=" "

    local a_element="$1"
    local a_delimiter="${2:-$default_delimiter}"
    local a_inputfile="$3"

    [[ -z $a_element ]] && return 1

    mysplit "$a_delimiter" "$a_inputfile" | \
        grep -v "^$a_element\$" | \
        myjoin "$a_delimiter"
}
##############################################################################




# @tags: canbescript
function echoe()
{
    echo "$@" 1>&2
}

