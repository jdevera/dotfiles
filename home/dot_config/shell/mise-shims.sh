# Put mise's shims first on PATH so every shell finds the tools mise installs:
# interactive or not, login or not, zsh or bash, scripts included. The shims
# resolve to the mise-installed binaries, the same ones an interactive shell
# gets from `mise activate`, so a script and a terminal run the same programs.
# POSIX sh on purpose: sourced from .zshenv, .zprofile, .bash_profile, .bashrc
# and via BASH_ENV for non-interactive bash. It moves the shims dir to the
# front even when PATH already holds it further back (an inherited PATH, or
# macOS path_helper reordering a login shell), and never adds it twice.
_mise_shims="$HOME/.local/share/mise/shims"
_new_path=""
_old_ifs="$IFS"
IFS=:
for _dir in $PATH; do
  [ "$_dir" = "$_mise_shims" ] && continue
  [ -z "$_dir" ] && continue
  _new_path="${_new_path:+$_new_path:}$_dir"
done
IFS="$_old_ifs"
PATH="$_mise_shims${_new_path:+:$_new_path}"
export PATH
unset _mise_shims _new_path _old_ifs _dir
