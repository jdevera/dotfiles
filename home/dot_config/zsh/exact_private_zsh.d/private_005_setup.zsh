
function is_osx()
{
   [[ $OSTYPE == darwin* ]]
}

# Set emacs keymap early, before plugins bind their keys
bindkey -e
