#!/usr/bin/env  sh

# Required programs: dirname, grep, sed, tail
# Tested on 2025-08-10 with fdupes 2.1.2
#   https://github.com/adrianlopezroche/fdupes
# Required programs:  cat, dirname, grep, sed, tail

#DEBUG=1
log_file=/tmp/debug.log

_debug() {
  [ "$DEBUG" = 1 ] || return
  if [ ! -s "$log_file" ]; then
    cat <<EOF > "$log_file"
This is a debugging log file for the fdupes file deletion reversion script.
Created $( \date  --utc  "+%Y-%m-%d - %H:%M:%S" )

log file:
$log_file

input_fdupes_logfile
$input_fdupes_logfile

output_file:
$output_file

Using command:
$custom_string

The full command which generated this was:
$0

----

EOF
  fi
  \echo "Debugging: $1"
  \echo "$1" >> "$log_file"
}

input_fdupes_logfile="$1"
output_file="$2"
# Default
custom_string="cp -a <source> <dest>"

_help() {
  \echo "Generates a shell script to process fdupes deletions with a custom command."
  \echo
  \echo "Usage: $0 <fdupes_log_file> <output_script> [--custom '<command> <source> <dest>' | left middle right]"
  \echo "  <fdupes_log_file>  Path to fdupes log file"
  \echo "  <output_script>    Path to output shell script"
  \echo "  --custom           Custom command with <source> and <dest> placeholders or three parts (left middle right)"
  \echo "                     Example: --custom 'ln -s <source> <dest>' or --custom left middle right"
  \echo "                     Default: \'$custom_string\'"
  return "$1"  2> /dev/null || { exit "$1"; }
}

# Sanity checking:
if [ "$1" = "--help" ]; then _help 0; fi
if [ -z "$*"         ]; then _help 1; fi
if [ ! -f "$input_fdupes_logfile" ]; then
  \echo "Error: fdupes log file does not exist:"
  \echo "$input_fdupes_logfile"
  return 1  2> /dev/null || { exit 1; }
fi
if [ -z "$output_file" ]; then
  \echo "Error: No output file specified:"
  \echo "$output_file"
  return 1  2> /dev/null || { exit 1; }
fi

if [ "$3" = "--custom" ]; then
  if [ -z "$4" ]; then
    \echo "Error: --custom requires a command string or three parts."
    _help 1
  fi
  shift 3
  if [ $# -eq 3 ]; then
    custom_string="$1<source>$2<dest>$3"
  else
    custom_string="$*"
  fi
fi

# Define reserved word variables
reserved_left="$$.$( \mktemp  --dry-run ).left"
reserved_middle="$$.$( \mktemp  --dry-run ).middle"
reserved_right="$$.$( \mktemp  --dry-run ).right"

# Extract working directory from log
wd="$( \grep '^working directory:' "$input_fdupes_logfile" | \sed 's/^working directory:[[:space:]]*//' )"
_debug "Extracted working directory: '$wd'"

# Initialize output script
cat <<EOF > "$output_file"
#!/bin/env  sh

# Text file created from fdupes deletions logfile:
# $input_fdupes_logfile
# Generated on $( \date  --utc  "+%Y-%m-%d - %H:%M:%S" )
# Using command:
# $custom_string
EOF

_debug "Starting while loop, reserved_right='$reserved_right'"
reserved_right=''
while IFS= read -r line; do
  if [ "$line" = '' ] || [ "$line" = ' ' ]; then
    continue
  fi

  _debug "Processing line: '$line'"

  # Handle deleted lines
  if \echo "$line" | \grep -q '^deleted[[:space:]]'; then
    # Extract deleted file path
    del="$( \echo "$line" | \sed 's/^deleted[[:space:]]\+//' )"
    _debug "Extracted del: '$del'"
    if [ -z "$reserved_right" ]; then
      reserved_right="$del"
    else
      reserved_right="$reserved_right
$del"
    fi
    _debug "Updated reserved_right: '$reserved_right'"
    continue
  fi

  # Handle left lines
  if \echo "$line" | \grep -q '^[[:space:]]*left[[:space:]]'; then
    # Extract left file path
    left_line="$( \echo "$line" | \sed 's/^[ \t]*//' )"
    reserved_left="$( \echo "$left_line" | \sed 's/^left[[:space:]]\+//' )"
    _debug "Extracted reserved_left: '$reserved_left'"
    reserved_middle="$IFS"
    IFS='
'
    _debug "Entering for loop with reserved_right: '$reserved_right'"
    for del in $reserved_right; do
      if [ -n "$del" ]; then
        # Generate custom command using debugged values
        source_path="$( \echo "$reserved_left" | \sed 's/\//\\\//g' )"
        dest_path="$( \echo "$del" | \sed 's/\//\\\//g' )"
        string="$( \echo "$custom_string" | \sed "s/<source>/$source_path/g; s/<dest>/$dest_path/g" )"
        _debug "Generated string: '$string'"
        if [ -n "$string" ]; then
          \echo "$string" >> "$output_file"
        fi
      fi
    done
    IFS="$reserved_middle"
    reserved_right=''
    _debug "Reset reserved_right: '$reserved_right'"
    continue
  fi
done < "$input_fdupes_logfile"

\echo "Generated output file: $output_file"
