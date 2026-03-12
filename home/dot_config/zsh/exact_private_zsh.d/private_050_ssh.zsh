# SSH session fixups
# Only relevant when SSH'd into this macOS machine

[[ -z $SSH_CONNECTION ]] && return

# macOS launchd SSH agent socket isn't inherited by SSH sessions.
# Find and export it so SSH keys from Keychain are available.
if [[ -z $SSH_AUTH_SOCK ]]; then
    local _socks=(/private/tmp/com.apple.launchd.*/Listeners(N))
    (( ${#_socks} )) && export SSH_AUTH_SOCK=$_socks[1]
fi
