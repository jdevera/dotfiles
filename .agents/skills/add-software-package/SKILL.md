---
name: add-software-package
description: >-
  Use when adding, removing, or changing how a software package / CLI tool /
  GUI app / runtime is installed in this chezmoi dotfiles repo. Covers the two
  data files to edit, the install-method priority order (native packages first;
  mise for release binaries and npm CLIs; uv for Python; node via mise), the spec
  schema, and how to verify the change.
---

# Adding a software package

Installation in this repo is **data-driven**. You almost never write a shell
script — you declare *what* to install in one file and *how* to install it in
another, and the existing templates generate the install scripts.

## The two files you edit

1. **`home/.chezmoidata/packages.yml`** — the *list* of what to install.
   - Add the package name under `packages:`.
   - Use `install_tools:` instead only for tools that must exist *before* the
     main package install runs (currently `mise`, `uv`). These run at step 030;
     packages run at 035.
   - Gate by platform/role with `only_when`, e.g.
     `- name: ghostty` / `  only_when: [gui]`. Valid tags: `macos`, `linux`,
     `gui`, `work`, `personal`.

2. **`home/.chezmoidata/package_specs.yml`** — *how* to install it. Add an entry
   keyed by the same name under `softwarePackages:` with one or more install
   methods (see below).

That's it. `run_onchange_after_035-install-packages.sh.tmpl` (and `030` for
install_tools) render from these via `install_packages.sh.tmpl`. A name listed
in `packages.yml` with no matching spec fails validation at step 005.

Only touch **`home/.chezmoidata/.package_specs.schema.yml`** if you introduce a
brand-new install *method* (rare).

## Install-method priority (the important part)

Pick methods in this order. The template resolves each package to the **first**
method that matches the current OS, so listing several is how you get
cross-platform coverage.

1. **Native OS package — preferred.** `brew` (macOS), `apt`/`dnf` (Linux). On
   Fedora prefer rpm/dnf. If a tool ships its **own RPM repo**, use the object
   form: `dnf: { package: foo, repo: https://example.com/foo.repo }` (added via
   `dnf config-manager addrepo`). COPR uses `dnf: { package: foo, copr: user/proj }`.
2. **Exception — stale native package.** If the packaged version tends to be old
   (most common on Debian/`apt`), skip it and use a cross-platform method below
   so you get a current version.
3. **GitHub release binary → `mise`.** Use `mise: aqua:owner/repo` when the tool
   is in the aqua registry (preferred — gives checksums + attestation), or
   `mise: github:owner/repo` for repos not in aqua (e.g. personal repos).
   - Do **not** use eget (removed) or the `ubi:` backend (deprecated by mise).
   - Verify it resolves: `mise ls-remote aqua:owner/repo`.
4. **npm-distributed CLI → `mise`.** Use `mise: npm:package-name`, e.g.
   `mise: npm:@openai/codex`. This keeps global npm CLIs under mise instead of
   ad hoc `npm install -g` scripts. Prefer an explicit `npm:` backend when a
   registry shorthand has multiple backends.
5. **Python CLI tool or interpreter → `uv`.** `uv: toolname`, or
   `uv: { name: tool, with: [extra] }`. uv owns Python; do not use mise for it.
6. **Runtime you develop against (e.g. node) → `mise`, no native package.** Omit
   brew/apt/dnf entirely and use only `mise: node@lts` so it lives in `$HOME` and
   global installs (`npm i -g`) don't need sudo. Omit `check` for these so
   `mise use --global` always asserts ownership even if a stray system copy is on
   PATH.
7. **macOS GUI app → `cask`.** Mac App Store app → `mas: <numeric-id>` (preferred
   over brew/cask when available).
8. **Last resort → `script`.** An inline shell one-liner. Pair with `check`.

Add **`check: { command: <bin> }`** to any spec so the install is skipped when
the command is already present (skip this for node — see #6). Required for
`mise`/`script` methods to be idempotent.

### Tier resolution order (what wins)

- macOS: `mas` → `brew` → `cask`
- Linux: `apt` → `dnf` (+`copr`/`repo`)
- Cross-platform fallback (either OS): `uv` → `mise` → `script`

First match wins. So a spec with both `dnf` and `mise` installs via dnf on
Fedora. To force mise everywhere, omit the OS-package methods (the node pattern).

## Examples

```yaml
# In a distro repo everywhere — native is enough:
bat:
  brew: bat
  apt: bat
  dnf: bat

# GitHub-release CLI not in distro repos — native on mac, mise elsewhere:
sops:
  brew: sops
  check: { command: sops }
  mise: aqua:getsops/sops

# Personal repo not in the aqua registry — github backend:
shdoc-ng:
  brew: jdevera/tap/shdoc-ng
  dnf: { package: shdoc-ng, copr: jdevera/shdoc-ng }
  check: { command: shdoc-ng }
  mise: github:jdevera/shdoc-ng

# npm-distributed CLI via mise:
codex:
  cask: codex
  check: { command: codex }
  mise: npm:@openai/codex

# Tool with its own RPM repo:
mise:
  brew: mise
  dnf: { package: mise, repo: https://mise.jdx.dev/rpm/mise.repo }

# Python CLI — uv:
tox:
  uv: { name: tox, with: tox-uv }

# Runtime in $HOME, no system package:
node:
  mise: node@lts

# macOS GUI app, gated:
#   packages.yml:  - name: raycast
#                    only_when: [macos]
raycast:
  cask: raycast
```

## Verify before committing

```bash
# See the generated install step for your package:
chezmoi execute-template < home/.chezmoiscripts/run_onchange_after_035-install-packages.sh.tmpl | grep -A3 <name>

# Validate every listed package has a spec (empty output = OK):
chezmoi execute-template < home/.chezmoiscripts/run_before_005_validate_data_packages.sh.tmpl

# For mise backends, confirm the spec resolves:
mise ls-remote <aqua:owner/repo | github:owner/repo>

# For npm-backed mise tools, confirm the backend is known:
mise registry <tool>

# Lint:
PREK_HOME="${TMPDIR:-/tmp}/codex-prek-home" prek run --all-files
```

## Gotchas

- **mise state is not tracked.** `mise use --global` writes tool versions to
  `~/.config/mise/config.toml`, which is **gitignored** — that file is realized
  machine state. The declarative mise config (settings, baseline tools) lives in
  the tracked `home/dot_config/mise/conf.d/dotfiles.toml`.
- **Which tools mise installs is declared here**, in `package_specs.yml` via the
  `mise:` tier — not in mise's config.
- **One-shot cleanup on existing machines?** If your change needs to undo old
  state (e.g. remove a stale binary), add a `run_once_after_NNN-*.sh.tmpl` with a
  `# EXPIRES: YYYY-MM-DD` marker. The prek `no-expired-scripts` hook fails once
  that date passes, so the dead script gets pruned. See
  `home/.chezmoiscripts/run_once_after_060-migrate-eget-to-mise.sh.tmpl`.
- Follow the commit convention: `Component: Short description`, no
  `Co-Authored-By` lines.
