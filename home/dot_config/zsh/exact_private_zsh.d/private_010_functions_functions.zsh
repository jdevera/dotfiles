#############################################################################
#
# FILE:         010_functions_functions.zsh
#
# DESCRIPTION:  Functions to handle shell functions (ZSH version)
#
#############################################################################



# Check if a function given by name is defined in the current shell instance
# @tags: canbescript
function function_exists()
{
   local a_function_name=$1

   [[ -z $a_function_name ]] && return 1

   (( $+functions[$a_function_name] ))
}

# If the function specified in the first parameter exists, call it with the
# subsequent parameters
function call_if()
{
   function_exists "$1" && "$@"
}

# Find the location where a function has been defined
# Uses ZSH's $functions_source associative array (ZSH 5.9+)
# Output format: function_name line_number file_path
# @tags: canbescript
function find_function()
{
   local fname="$1"
   (( $+functions[$fname] )) || return 1

   # $functions_source is available in ZSH 5.9+
   if (( $+functions_source )); then
      local source_file="${functions_source[$fname]}"
      if [[ -n $source_file ]]; then
         # Extract line number by searching for the function definition in the source file
         local lineno
         lineno=$(grep -n "function ${fname}\b\|${fname}()" "$source_file" 2>/dev/null | head -1 | cut -d: -f1)
         lineno=${lineno:-0}
         echo "$fname $lineno $source_file"
         return 0
      fi
   fi

   # Fallback: just report the function exists but we can't find its source
   echo "$fname 0 unknown"
}

# Output the names of all functions defined in the current shell
# @tags: command canbescript
function dump_functions()
{
   functions
}

# Show a pretty printed list of shell functions, sorted by file and line
# @tags: command canbescript
function list_functions()
{
   if ! (( $+functions_source )); then
      echo "list_functions requires ZSH 5.9+ (\$functions_source not available)"
      return 1
   fi

   local fname source_file
   for fname in ${(ko)functions}; do
      source_file="${functions_source[$fname]}"
      [[ -z $source_file ]] && continue
      # Skip completion functions
      [[ $source_file == *completion* ]] && continue
      local lineno
      lineno=$(grep -n "function ${fname}\b\|${fname}()" "$source_file" 2>/dev/null | head -1 | cut -d: -f1)
      lineno=${lineno:-0}
      echo "$fname $lineno $source_file"
   done |
   sort -k3 -k2.1n |
   awk 'BEGIN{
      prev = 0
   }
   {
      if (prev != $3) {
         print "\n" $3
         prev = $3
      }
      printf("%4s\t%s\n", $2, $1)
   }' |
   colout '^/.*' cyan
}


# View all defined functions in vim
# @tags: command canbescript
function viewfuncs()
{
   if ! (( $+functions_source )); then
      echo "viewfuncs requires ZSH 5.9+ (\$functions_source not available)"
      return 1
   fi

   local output=""
   local prev_file=""
   local fname source_file lineno

   for fname in ${(ko)functions}; do
      source_file="${functions_source[$fname]}"
      [[ -z $source_file ]] && continue
      [[ $source_file == *completion* ]] && continue
      lineno=$(grep -n "function ${fname}\b\|${fname}()" "$source_file" 2>/dev/null | head -1 | cut -d: -f1)
      lineno=${lineno:-0}
      echo "$fname $lineno $source_file"
   done |
   sort -k3 -k2.1n |
   while read -r fname lineno source_file; do
      if [[ $source_file != "$prev_file" ]]; then
         [[ -n $prev_file ]] && output+="# }}}\n"
         output+="# FILE: $source_file {{{\n"
         prev_file=$source_file
      fi
      output+="## FUNCTION: $fname (line $lineno) {{{\n"
      output+="$(functions "$fname")\n"
      output+="# }}}\n"
   done
   [[ -n $prev_file ]] && output+="# }}}\n"

   echo "$output" | view - +'se ft=zsh fdm=marker'
}
