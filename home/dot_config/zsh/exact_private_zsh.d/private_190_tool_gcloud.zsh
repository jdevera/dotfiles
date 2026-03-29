# Google Cloud SDK
_gcloud_sdk="$HOME/.local/share/google-cloud-sdk"

if [[ -d "$_gcloud_sdk" ]]; then
    pathprepend "$_gcloud_sdk/bin"

    # Completions
    [[ -f "$_gcloud_sdk/completion.zsh.inc" ]] && source "$_gcloud_sdk/completion.zsh.inc"
fi

unset _gcloud_sdk
