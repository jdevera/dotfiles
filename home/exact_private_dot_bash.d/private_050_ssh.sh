# SSH session fixups
# Only relevant when SSH'd into this macOS machine

[[ -z $SSH_CONNECTION ]] && return

# macOS launchd SSH agent socket isn't inherited by SSH sessions.
# Find and export it so SSH keys from Keychain are available.
if [[ -z $SSH_AUTH_SOCK ]]; then
    for _sock in /private/tmp/com.apple.launchd.*/Listeners; do
        if [[ -S $_sock ]]; then
            export SSH_AUTH_SOCK=$_sock
            break
        fi
    done
    unset _sock
fi
