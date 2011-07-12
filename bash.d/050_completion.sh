# Bash completion for rabbitvcs modules
# ---------------------------------------------------------------------------
_rabitvcs_opts()
{
    rabbitvcs 2>&1 |
    sed '
        5,/^$/!d
        s/,\s*/,/g
    ' |
    awk -F',' '
        {
            for (i = 1; i < NF; i++) { arr[length(arr)] = $i }
        }
        END{
            for (e in arr) { print arr[e] }
        }' | 
    grep "$2.*";
}
complete -C _rabitvcs_opts -o default rabbitvcs

# ---------------------------------------------------------------------------
