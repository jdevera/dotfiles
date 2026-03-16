# Plugin configuration
# Runs after plugins are loaded (006), uses plug::is_loaded for conditionals

if plug::is_loaded zsh-autosuggestions; then
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi
