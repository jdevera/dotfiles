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

### Zsh

The interactive shell. Modular config lives in `.config/zsh/zsh.d/`, loaded
in order:
1. `zsh.d/local/before/*` (machine-specific, untracked)
2. `zsh.d/*` (the good stuff)
3. `zsh.d/local/after/*` (machine-specific overrides)

Plugins are declared in `.chezmoidata/zsh_plugins.yaml` and pulled as chezmoi
externals — no framework needed.

To apply changes: `chezmoi apply`, then `rlsh` to reload in the current shell.

### Bash

Retired as an interactive shell, kept usable for emergencies (broken zsh
config, half-bootstrapped machine). One minimal, self-sufficient file:
`.config/bash/init.bash`.

`~/.bashrc` itself is deliberately *unmanaged* — every tool under the sun
appends to it, and they can have it. A chezmoi script just keeps one line in
there that loads the managed file.

### Starship Prompt ✨

Fancy prompt with [Starship](https://starship.rs/), Catppuccin colors, and
Nerd Font icons.

Two flavors generated from one template:
- **Full Unicode:** Hearts 󰋑, fancy arrows ❯, the works
- **ASCII-safe:** For terminals that can't handle the truth
  (I'm looking at you Ghostty 👀. I love you, but why?!)

The shell auto-detects and switches configs.

**Layered config architecture:**

```
nerd-font-symbols.toml   (preset from starship.rs, stored in repo)
        ↓ merge
starship.yml             (custom: palettes, character symbols, modules)
        ↓ merge
starship.toml            (final output)
```

Nerd Font symbols live in a separate file so they won't get corrupted
if tools mangle the template. Customizations are in YAML, merged at apply time.

**Checking for preset updates:**

```sh
./tools/starship-diff
```

Compares your config against the upstream nerd-font-symbols preset.
Shows new symbols you might want to add.

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
