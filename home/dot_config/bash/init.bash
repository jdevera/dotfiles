# Minimal bash configuration, managed by chezmoi.
#
# Zsh is the interactive shell; this file only makes bash *usable* for the
# times it shows up anyway: recovering from a broken zsh config, a fresh
# machine mid-bootstrap, or a quick `bash` from zsh. It is deliberately
# self-sufficient (no inherited environment assumed) and deliberately small.
#
# ~/.bashrc is intentionally NOT managed by chezmoi so that tools can append
# to it freely without creating conflicts. It sources this file via a line
# that a chezmoi script keeps in place.

# Interactive shells only
[[ $- != *i* ]] && return

# ------------------------------------------------------------------------------
# Locale (macOS)
# ------------------------------------------------------------------------------
# macOS is configured with AppleLocale=en_ES (English language, Spain region),
# which has no matching Unix locale, so the terminal derives an invalid
# LC_CTYPE=UTF-8 and bash complains about setlocale. Fix: explicitly set a
# valid locale. en_IE.UTF-8 gives British English spelling, metric system,
# euro, 24-hour time, and dd/MM/yyyy dates. (Same fix lives in ~/.zshenv.)
if [[ $OSTYPE == darwin* ]]; then
    export LANG=en_IE.UTF-8
    export LC_ALL=en_IE.UTF-8
fi

# ------------------------------------------------------------------------------
# PATH insurance
# ------------------------------------------------------------------------------
# Just enough to find tools when this is the only working shell. The full
# environment setup lives in the zsh config.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x $_brew ]]; then
        eval "$("$_brew" shellenv)"
        break
    fi
done
unset _brew

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac

# ------------------------------------------------------------------------------
# History and shell options
# ------------------------------------------------------------------------------
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------
if command -v starship > /dev/null 2>&1; then
    eval "$(starship init bash)"
else
    PS1='\u@\h:\w\$ '
fi

# Machine-specific additions, if any
# shellcheck source=/dev/null
[[ -f $HOME/.bash.local ]] && source "$HOME/.bash.local"
