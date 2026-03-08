# @tags: canbescript
function ansi_color()
{
   local color
   case "$1" in
      black)        color="\e[0;30m";;
      red)          color="\e[0;31m";;
      green)        color="\e[0;32m";;
      brown)        color="\e[0;33m";;
      blue)         color="\e[0;34m";;
      purple)       color="\e[0;35m";;
      cyan)         color="\e[0;36m";;
      light_gray)   color="\e[0;37m";;
      dark_gray)    color="\e[1;30m";;
      light_red)    color="\e[1;31m";;
      light_green)  color="\e[1;32m";;
      yellow)       color="\e[1;33m";;
      light_blue)   color="\e[1;34m";;
      light_purple) color="\e[1;35m";;
      light_cyan)   color="\e[1;36m";;
      white)        color="\e[1;37m";;
      none)         color="\e[0m";;
   esac
   echo "$color"
}

# @tags: canbescript
function ansi_color256()
{
   printf '\033[38;5;%sm' "$1"
}

# @tags: canbescript
# DEPENDS-ON: ansi_color
function colorise() {
    local OFF="\e[0m"
    local color=$1
    shift
    echo "$(ansi_color "$color")$*$OFF"
}

# @tags: canbescript
function ansi_effect() {
    local effect
    case "$1" in
    bold) effect="\e[1m" ;;
    italic) effect="\e[3m" ;;
    underline) effect="\e[4m" ;;
    strikethrough) effect="\e[9m" ;;
    none) effect="\e[0m" ;;
    esac
    echo "$effect"
}

# @tags: canbescript
function effected() {

    local OFF="\e[0m"
    local effect=$1
    shift
    echo "$(ansi_effect "$effect")$*$OFF"
}
