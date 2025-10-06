#!/bin/sh

# Install your password manager on init

# If you use a password manager to store your secrets then you may need to
# install your password manager after you have run chezmoi init on a new machine
# but before chezmoi init --apply or chezmoi apply executes your run_before_
# scripts.
#
# chezmoi provides a hooks.read-source-state.pre hook that allows you to modify
# your system after chezmoi init has cloned your dotfile repo but before chezmoi
# has read the source state. This is the perfect time to install your password
# manager as you can assume that ~/.local/share/chezmoi is populated but has not
# yet been read.
#
# First, write your password manager install hook. chezmoi executes this hook
# every time any command reads the source state so the hook should terminate as
# quickly as possible if there is no work to do.
#
# This hook is not a template so you cannot use template variables and must
# instead detect the system you are running on yourself.
#
# Sources:
# https://www.chezmoi.io/user-guide/advanced/install-your-password-manager-on-init/
# https://support.1password.com/install-linux/
# https://developer.1password.com/docs/cli/get-started
#

has_command() {
	type "$1" >/dev/null 2>&1
}

# exit immediately if password-manager-binary is already in $PATH
has_command op && exit 0

SYSTEM="$(uname -s | tr '[:upper:]' '[:lower:]')"

__INSTALL_DIR="$HOME/.local/bin"
__STEP_NUMBER=0
__STEP_LABEL=""
__TMP_DIR=""
__NEED_PACKAGE_CACHE_UPDATE=1

die() {
	log "ERROR: $*"
	exit 1
}
log() {
	echo "[BOOTSTRAP 1Password] $*" >&2
}

step_start() {
	__STEP_NUMBER=$((__STEP_NUMBER + 1))
	__STEP_LABEL="$1"
	log "=> Step $__STEP_NUMBER: will $__STEP_LABEL"
}

step_done() {
	log "✓ $__STEP_LABEL $*"
}

step_fatal() {
	log "✗ ERROR: could not $__STEP_LABEL $*"
	exit 1
}

is_macos() {
	[ "$SYSTEM" = "darwin" ]
}

is_linux() {
	[ "$SYSTEM" = "linux" ]
}

linux_arch() {
	# One of 386/amd64/arm/arm64
	__linux_arch=$(uname -m)
	case "$__linux_arch" in
	x86_64)
		echo "amd64"
		;;
	aarch64 | arm64)
		echo "arm64"
		;;
	armv7l)
		echo "arm"
		;;
	i686)
		echo "386"
		;;
	*)
		die "unsupported architecture: $__linux_arch"
		;;
	esac
}

darwin_arch() {
	__darwin_arch=$(machine)
	case "$__darwin_arch" in
	arm64*)
		echo "arm64"
		;;
	*)
		log "Arch was $__darwin_arch, using amd64"
		echo "amd64"
		;;
	esac
}

get_arch() {
	if is_macos; then
		darwin_arch
	else
		linux_arch
	fi
}

get_latest_op_version() {
	curl -sSL https://app-updates.agilebits.com/check/1/0/CLI2/en/2.0.0/N |
		grep -Eo '[0-9]+\.[0-9]+\.[0-9]+'
}

get_op_url() {
	__os="$1"
	__arch="$2"
	__version="$3"
	echo "https://cache.agilebits.com/dist/1P/op2/pkg/v${__version}/op_${__os}_${__arch}_v${__version}.zip"
}

checked_step() {
	"$@" || step_fatal
	step_done
}

apt_install() {
	__package="$1"
	if ! has_command apt-get; then
		die "missing command apt-get, cannot install $__package"
	fi
	if ! has_command sudo; then
		die "missing command sudo, cannot install $__package"
	fi
	if [ "$__NEED_PACKAGE_CACHE_UPDATE" = 1 ]; then
		sudo apt-get update --quiet --quiet
		__NEED_PACKAGE_CACHE_UPDATE=0
	fi
	sudo apt-get install --no-install-recommends --quiet -y "$__package"

}

ensure_command() {
	__command="$1"
	__package="$2"
	has_command "$__command" && return
	if is_macos; then
		die "Missing command $__command"
	fi
	apt_install "$__package"
}

step_start "check system type"
if ! is_macos && ! is_linux; then
	step_fatal ": unsupported OS: $SYSTEM"
else
	step_done " : $SYSTEM"
fi

if is_macos && has_command brew; then
	step_start "install 1Password CLI with Homebrew"
	checked_step brew install 1password-cli
	exit 0
fi

step_start "check architecture"
ARCH=$(get_arch)
[ -n "$ARCH" ] || step_fatal
step_done " : $ARCH"

step_start "get the latest 1Password CLI version"
OP_VERSION=$(get_latest_op_version)
[ -n "$OP_VERSION" ] || step_fatal
step_done " : $OP_VERSION"

step_start "create temp dir for 1Password CLI distribution"
__TMP_DIR=$(mktemp -d)
[ -n "$__TMP_DIR" ] || step_fatal
trap 'rm -rf "$__TMP_DIR"' EXIT
step_done " : $__TMP_DIR"

step_start "get the 1Password CLI URL"
OP_URL=$(get_op_url "$SYSTEM" "$ARCH" "$OP_VERSION")
[ -n "$OP_URL" ] || step_fatal
step_done " : $OP_URL"

step_start "download the 1Password CLI"
checked_step \
	curl -SL --progress-bar "$OP_URL" -o "$__TMP_DIR/op.zip"

if is_macos; then
	# unzip is included by default on macOS, no need to install
	has_command unzip || die "unzip not found (should be in /usr/bin/unzip on macOS)"
else
	step_start "ensure unzip is installed"
	checked_step \
		ensure_command unzip unzip
fi

step_start "unzip the 1Password CLI"
checked_step \
	unzip -d "$__TMP_DIR/op" "$__TMP_DIR/op.zip"

# We can try to install gpg in linux systems, because they have a package
# manager built in. MacOS has Brew, but it is not installed by default.
# By the time this is run, it can be very early in the setup process, so
# we cannot assume that Brew is installed.
if ! has_command gpg && [ "$SYSTEM" = "linux" ]; then
	step_start "install gpg"
	checked_step \
		ensure_command gpg gpg
fi

if has_command gpg; then
	step_start "download the 1Password CLI keys"
	checked_step \
		gpg --keyserver keyserver.ubuntu.com --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22

	step_start "verify the 1Password CLI signature"
	checked_step \
		gpg --verify "$__TMP_DIR/op/op.sig" "$__TMP_DIR/op/op"
else
	log "WARNING: gpg is not installed, skipping signature verification"
fi

step_start "ensure installation directory exists"
checked_step \
	mkdir -p "$__INSTALL_DIR"

step_start "move the 1Password CLI to $__INSTALL_DIR"
checked_step \
	mv "$__TMP_DIR/op/op" "$__INSTALL_DIR/op"

step_start "make the 1Password CLI executable"
checked_step \
	chmod +x "$__INSTALL_DIR/op"

step_start "check the 1Password CLI is installed"
checked_step \
	op --version

case ":$PATH:" in
	*:"$__INSTALL_DIR":*)
		log "✓ $__INSTALL_DIR is already in PATH"
		;;
	*)
		log "WARNING: $__INSTALL_DIR is not in PATH. Add it to your shell profile:"
		log "  export PATH=\"\$PATH:$__INSTALL_DIR\""
		;;
esac
