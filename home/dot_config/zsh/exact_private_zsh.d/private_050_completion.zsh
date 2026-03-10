# ZSH completion system {{{
# ---------------------------------------------------------------------------

# Custom completions directory managed by chezmoi
fpath=(~/.config/zsh/completions $fpath)

# Load all completions from linuxbrew
if [[ -d /home/linuxbrew/.linuxbrew/share/zsh/site-functions ]]; then
    fpath=(/home/linuxbrew/.linuxbrew/share/zsh/site-functions $fpath)
fi
if [[ -d ~/.linuxbrew/share/zsh/site-functions ]]; then
    fpath=(~/.linuxbrew/share/zsh/site-functions $fpath)
fi

# Initialize the completion system (must be after fpath additions)
autoload -Uz compinit && compinit

# Git completion for aliases (must be after compinit)
compdef g=git
compdef tit=git

# Menu selection: highlight the current completion
zstyle ':completion:*' menu select

# Accept completion and execute with Enter (like bash)
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line

# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Colored completions using LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ---------------------------------------------------------------------------
# }}}
# ANSI colours {{{
# ---------------------------------------------------------------------------
function __complete_ansi_color()
{
   local -a colors
   colors=(black red green brown blue purple cyan light_gray dark_gray light_red light_green yellow light_blue light_purple light_cyan white none)
   compadd -a colors
}
compdef __complete_ansi_color ansi_color
compdef __complete_ansi_color set_prompt_color
# ---------------------------------------------------------------------------
# }}}
# New program template {{{
# ---------------------------------------------------------------------------
function __complete_new()
{
   local -a templates
   templates=(${(f)"$(ls "$SOURCE_TEMPLATES" 2>/dev/null)"})
   compadd -a templates
}
compdef __complete_new new
# ---------------------------------------------------------------------------
# }}}
