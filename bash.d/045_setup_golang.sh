# 45_golang.sh
# Clean Go environment setup using XDG-like layout
#
# This configuration organizes Go-related directories following XDG Base Directory
# conventions, keeping your home directory clean and organized.

# =============================================================================
# WORKSPACE AND BINARY LOCATIONS
# =============================================================================

# Go workspace directory (legacy GOPATH - still used by Go for some operations)
# Contains: src/, pkg/, bin/ subdirectories in traditional GOPATH mode
# Modern usage: Mainly used as fallback location for various Go operations
export GOPATH="$HOME/.local/share/go"

# Directory where 'go install' places executable binaries
# This overrides the default behavior of installing to $GOPATH/bin
# What goes here: All binaries from 'go install pkg@version' commands
# Examples: ~/local/bin/air, ~/.local/bin/goimports, ~/.local/bin/gopls
export GOBIN="$HOME/.local/bin"

# =============================================================================
# CACHE DIRECTORIES
# =============================================================================

# Go module download cache - where 'go get' stores downloaded module source code
# What goes here: Downloaded module source code and metadata
# Structure: $GOMODCACHE/github.com/user/repo@version/
# Examples: ~/.cache/go/mod/github.com/gin-gonic/gin@v1.9.1/
export GOMODCACHE="$HOME/.cache/go/mod"

# Go build cache - stores compiled intermediate build artifacts
# What goes here: Compiled object files (.a files), test results, build metadata
# Purpose: Speeds up subsequent builds by reusing compiled components
# Structure: Managed internally by Go (hash-based directory names)
export GOCACHE="$HOME/.cache/go/build"

# =============================================================================
# CONFIGURATION
# =============================================================================

# Location of Go's environment configuration file
# What goes here: Persistent Go environment settings set via 'go env -w'
# File: ~/.config/go/env (contains KEY=VALUE pairs)
# Examples: GOPROXY=https://proxy.golang.org,direct stored persistently
export GOENV="$HOME/.config/go/env"

# =============================================================================
# PATH CONFIGURATION
# =============================================================================

# Add Go binaries to PATH
# Only GOBIN is needed since we explicitly set where binaries are installed
# When GOBIN is set, all 'go install' commands place binaries there
export PATH="$GOBIN:$PATH"

# =============================================================================
# WHAT HAPPENS WHERE - SUMMARY
# =============================================================================
#
# When you run 'go install github.com/user/tool@latest':
#   → Binary goes to: $GOBIN (~/local/bin/tool)
#
# When you run 'go get' or 'go mod download':
#   → Module source goes to: $GOMODCACHE (~/cache/go/mod/github.com/user/tool@version/)
#
# When you run 'go build' or 'go test':
#   → Build artifacts cached in: $GOCACHE (~/cache/go/build/hash-named-dirs/)
#
# When you run 'go env -w SOME_VAR=value':
#   → Setting stored in: $GOENV (~/config/go/env)
#
# Legacy GOPATH usage (rarely needed in module mode):
#   → Fallback workspace: $GOPATH (~/local/share/go/)
#
# =============================================================================

# Installation behavior verification:
# - 'go install' with GOBIN set → always goes to $GOBIN
# - No more surprises about where tools end up
# - Clean separation of binaries, cache, config, and workspace
# - Follows XDG conventions for a tidy home directory
#
# -- Claude 2025-09-13
