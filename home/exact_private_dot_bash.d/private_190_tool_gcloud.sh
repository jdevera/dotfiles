# Google Cloud SDK
_gcloud_sdk="$HOME/.local/share/google-cloud-sdk"

if [[ -d "$_gcloud_sdk" ]]; then
    pathprepend "$_gcloud_sdk/bin"

    # Completions
    # shellcheck disable=SC1091
    [[ -f "$_gcloud_sdk/completion.bash.inc" ]] && source "$_gcloud_sdk/completion.bash.inc"
fi

unset _gcloud_sdk
