# 45_golang.zsh
# Clean Go environment setup using XDG-like layout
#
# This configuration organizes Go-related directories following XDG Base Directory
# conventions, keeping your home directory clean and organized.

# =============================================================================
# WORKSPACE AND BINARY LOCATIONS
# =============================================================================

# Go workspace directory (legacy GOPATH - still used by Go for some operations)
export GOPATH="$HOME/.local/share/go"

# Directory where 'go install' places executable binaries
export GOBIN="$HOME/.local/bin"

# =============================================================================
# CACHE DIRECTORIES
# =============================================================================

# Go module download cache
export GOMODCACHE="$HOME/.cache/go/mod"

# Go build cache
export GOCACHE="$HOME/.cache/go/build"

# =============================================================================
# CONFIGURATION
# =============================================================================

# Location of Go's environment configuration file
export GOENV="$HOME/.config/go/env"

# =============================================================================
# PATH CONFIGURATION
# =============================================================================

# Add Go binaries to PATH
export PATH="$GOBIN:$PATH"
