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
