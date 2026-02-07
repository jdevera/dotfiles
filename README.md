# 🏠 Jacobo's Dotfiles

> Accumulated shell wisdom, bad habits, and strong opinions since 2010

My config files for Linux and macOS. Managed with the wonderful
[chezmoi](https://www.chezmoi.io/). Seriously, if you're not using it,
you're missing out.

## ⚡ Installation

For me (hi, future me!):

```sh
sh -c "$(curl -fsLS jdevera.casa/install)"
```

## ⚠️ For Everyone Else

**Don't.** Seriously.

Dotfiles are like underwear: highly personal, and you probably don't want mine.
If you clone and run this, you will get *my* shell, *my* keybindings, *my* aliases,
and a very confused terminal. A friend tried this once. It did not end well.

But! Feel free to explore, steal ideas, and get inspired to start your own.
That's the spirit of dotfiles repos. Questions? Open an issue.

## 🛠️ Common Commands

| Command | What it does |
|---------|--------------|
| `chezmoi apply` | Make it so |
| `chezmoi diff` | What would change? |
| `chezmoi update` | Pull + apply |
| `chezmoi cd` | Teleport to source dir |

---

## 🐚 Shell

### Bash

Config lives in `.bash.d/`, loaded in order:
1. `.bash.d/local/before/*` (machine-specific, untracked)
2. `.bash.d/*` (the good stuff)
3. `.bash.d/local/after/*` (machine-specific overrides)

*"But isn't sourcing multiple files slow?"* I tested concatenating everything
into one file in 2026. The difference was negligible. Modularity wins.

To apply changes: `chezmoi apply`, then `rlsh` to reload in the current shell.

### Starship Prompt ✨

Fancy prompt with [Starship](https://starship.rs/), Catppuccin colors, and
Nerd Font icons.

Two flavors generated from one template:
- **Full Unicode:** Hearts 󰋑, fancy arrows ❯, the works
- **ASCII-safe:** For terminals that can't handle the truth
  (I'm looking at you Ghostty 👀. I love you, but why?!)

The shell auto-detects and switches configs.

---

## 📝 Editors

### Vim

Plugins managed with [vim-plug](https://github.com/junegunn/vim-plug).
Point at repos, it handles the rest.

### Emacs

> 💀 *Haven't touched this in years. Here be dragons.*

Uses [el-get](https://github.com/dimitri/el-get). Probably broken.

---

## 🖥️ Terminal Emulators

### iTerm2 (macOS)

Prefs sync to `~/.config/iterm2/settings/`.

**Gotcha:** Sync is one-way while running. To apply dotfile changes:
1. Quit iTerm2
2. `chezmoi apply`
3. Reopen

### Ghostty

Has Unicode rendering quirks, so the shell auto-switches to ASCII-safe prompt.
Config is just a file, no weird sync dance needed.

<!--
vim:linebreak:textwidth=78:spell:
-->
