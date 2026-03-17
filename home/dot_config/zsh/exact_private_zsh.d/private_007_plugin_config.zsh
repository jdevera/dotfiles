# Plugin configuration
# Runs after plugins are loaded (006), uses plug::is_loaded for conditionals

if plug::is_loaded zsh-autosuggestions; then
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

if plug::is_loaded zsh-ai-cmd; then
    ZSH_AI_CMD_PROVIDER=anthropic
    ZSH_AI_CMD_ANTHROPIC_MODEL=claude-haiku-4-5-20251001
    ZSH_AI_CMD_KEYCHAIN_NAME='zsh-ai-cmd-${provider}'
fi
