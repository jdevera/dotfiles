# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a chezmoi-managed dotfiles repository for macOS and Linux machines. The source directory is `home/` which maps to the user's home directory.

## Common Commands

```bash
chezmoi apply              # Apply dotfiles to home directory
chezmoi diff               # Preview changes (scripts excluded by config)
chezmoi update             # Pull latest and apply
chezmoi managed            # List all managed files
chezmoi data               # Show template data values
```

## Chezmoi Naming Conventions

Files in `home/` use chezmoi prefixes:
- `dot_` → `.` (e.g., `dot_bashrc` → `.bashrc`)
- `private_` → file permissions 0600
- `exact_` → directory is exact (unmanaged files are removed)
- `.tmpl` suffix → file is a Go template
- `run_before_`, `run_once_after_`, `run_onchange_after_` → script execution order

## Template Variables

Available in `.tmpl` files (defined in `home/.chezmoi.toml.tmpl`):

| Variable | Description |
|----------|-------------|
| `.is_macos` / `.is_linux` | OS detection |
| `.is_interactive` | Machine with direct user interaction (all macOS, specific Linux hosts) |
| `.is_headless` | No GUI (Linux servers, opposite of interactive) |
| `.is_work` | Work machine vs personal |
| `.email`, `.fname`, `.ghuser` | Personal info from 1Password |
| `.copy_command` | Clipboard command (`pbcopy` or `xsel`) |

## Architecture

### Script Library (`home/.chezmoitemplates/dotfiles_bashlib.sh`)

All chezmoi scripts should include this library for consistent output:
```bash
{{ template "dotfiles_bashlib.sh" . }}
```

Key functions:
- `dot::chezmoi_script_start "Script Name"` - Start a script with banner
- `dot::step::start "description"` - Begin a step
- `dot::step::done` / `dot::step::skipped` / `dot::step::fatal` - End a step
- `dot::has_command "cmd"` - Check if command exists
- `dot::os::setup` - Set up PATH for current OS

### Bash Configuration (`home/exact_private_dot_bash.d/`)

Modular bash config loaded by `.bashrc` in order:
1. `.bash.d/local/before/*` (untracked, machine-specific)
2. `.bash.d/*` (tracked modules)
3. `.bash.d/local/after/*` (untracked, machine-specific)

Files are named with numeric prefixes for ordering (e.g., `010_functions_*.sh`).

### ZSH Configuration (`home/dot_config/zsh/`)

Modular zsh config loaded by `.zshrc` via `dot::bootstrap`:
1. `.config/zsh/zsh.d/local/before/*` (untracked, machine-specific)
2. `.config/zsh/zsh.d/*` (tracked modules)
3. `.config/zsh/zsh.d/local/after/*` (untracked, machine-specific)

Files are named with numeric prefixes for ordering (e.g., `005_plugin_loader.zsh`).

#### Bootstrap (`bootstrap.zsh`)

The bootstrap defines core functions for the zsh startup lifecycle:
- `dot::bootstrap` - Entry point called from `.zshrc`, runs setup/source/cleanup
- `dot::source_file`, `dot::source_dir`, `dot::source_zsh_d` - Source helpers
- `dot::timing::setup/teardown` - Optional startup timing (`ZSH_TIME_STARTUP=1`)

#### Deferred Cleanup (`dot::defer`)

Register commands to run after all startup files have been sourced. Runs in LIFO order (last registered, first executed). The defer system cleans up itself on exit.

```zsh
dot::defer "unset _my_temp_var"
dot::defer "unfunction my_helper"
```

All bootstrap functions, plugin loader state, and timing variables are cleaned up via `dot::defer` — none survive into the interactive session.

#### ZSH Plugin System

Data-driven plugin management without a framework. Plugins are defined in `home/.chezmoidata/zsh_plugins.yaml` and downloaded as chezmoi `git-repo` externals into `~/.config/zsh/plugins/`.

**Data file** (`zsh_plugins.yaml`):
```yaml
# Single-plugin repo (name defaults to repo name):
- repo: zsh-users/zsh-autosuggestions
  description: "Fish-like autosuggestions"

# Multi-plugin repo (name defaults to last segment of path):
- repo: ohmyzsh/ohmyzsh
  description: "Plugin source"
  plugins:
    - path: plugins/git
    - path: plugins/docker
      source: docker.plugin.zsh  # only if non-standard
```

**Key files:**
- `005_plugin_loader.zsh` - Defines `plug::load` and `plug::is_loaded` (static)
- `006_plugin_load.zsh.tmpl` - Generated `plug::load` calls from YAML
- `007_plugin_config.zsh` - Plugin configuration using `plug::is_loaded` guards
- `~/.config/zsh/plugins_ignore` - Local ignore list (one plugin name per line, `create_` managed)
- `zsh_plugins.toml.tmpl` - Generated chezmoi externals from YAML

**Namespaces:**
- `dot::` - Bootstrap and startup lifecycle (defined in `bootstrap.zsh`)
- `plug::` - Plugin loading and state (defined in `005_plugin_loader.zsh`)

Both namespaces are fully cleaned up after startup via `dot::defer`.

### External Dependencies (`home/.chezmoiexternals/`)

External tools pulled via chezmoi's external mechanism (git repos, archives). Each `.toml` file defines one or more externals.

### Package Management

- `home/.chezmoidata/packages.yml` - Package definitions for APT/Homebrew
- `home/.chezmoidata/package_specs.yml` - Software installation specs (with JSON schema validation)
- `Brewfile` - Homebrew bundle for macOS

## Key Files

- `home/.chezmoi.toml.tmpl` - Main chezmoi config, defines all template variables
- `home/.install-one-password.sh` - Pre-hook: installs 1Password CLI before template processing
- `home/.chezmoiscripts/` - Installation and setup scripts (ordered by prefix)
- `site/install` - Bootstrap script for fresh installations

## Secrets

All secrets are stored in 1Password and accessed via `onepasswordRead` in templates. Never hardcode sensitive values.

## Git Commit Convention

Commit messages follow the format: `Component: Short description`

Examples from the repo:
- `Bashmarks: Migrate to XDG layout with dotfiles/local split`
- `Starship: Refactor to layered config with separate preset file`
- `Bash: Add iTerm2 shell integration via chezmoiexternal`

Do not add `Co-Authored-By` lines.

## Chezmoi Documentation

When you need chezmoi information, use these sources in order:

1. **Built-in knowledge** - Claude has extensive chezmoi knowledge from training
2. **`chezmoi help <command>`** - Run via Bash for command-specific details
3. **Online docs** - Fetch from `https://www.chezmoi.io/` (note: may reference newer chezmoi versions than installed)
