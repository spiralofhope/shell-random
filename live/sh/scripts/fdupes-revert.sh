#!/bin/sh

# Required programs: dirname, grep, sed, tail
# Tested on 2025-08-10 with fdupes 2.1.2
#   https://github.com/adrianlopezroche/fdupes
# Required programs:  cat, dirname, grep, sed, tail



input_fdupes_logfile="$1"
output_file="$2"
# Default
custom_string="\cp --archive <source> <dest>"


_help() {
  \echo "Generates a shell script to process fdupes deletions with a custom command."
  \echo
  \echo "Usage: $0 <fdupes_log_file> <output_script> [--custom '<command> <source> <dest>']"
  \echo "  <fdupes_log_file>  Path to fdupes log file"
  \echo "  <output_script>    Path to output shell script"
  \echo "  --custom           Custom command with <source> and <dest> placeholders"
  \echo "                     Example: --custom 'ln -s <source> <dest>'"
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
    \echo "Error: --custom requires a command string."
    _help 1
  fi
  custom_string="$4"
fi


# Extract working directory from log
wd=$( \grep -A1 "working directory:" "$input_fdupes_logfile" | \tail -1 | \sed 's/^[ \t]*//' )


# Initialize output script
cat <<EOF > "$output_file"
#!/bin/env  sh

# Text file created from fdupes deletions logfile:
# $logfile
# Generated on $( \date  --utc  "+%Y-%m-%d - %H։%M։%S" )
# Using command:
# $custom_string
EOF

deleted=''
while IFS= read -r line; do
  case "$line" in
    deleted\ *)
      # Extract deleted file path
      del=$( \echo "$line" | \sed 's/^deleted //' )
      if [ -z "$deleted" ]; then
        deleted="$del"
      else
        deleted="$deleted
$del"
      fi
    ;;
    *[[:blank:]]*left\ *)
      # Extract left file path
      left_line=$( \echo "$line"      | \sed 's/^[ \t]*//' )
      left=$(      \echo "$left_line" | \sed 's/^left //'  )
      oldIFS="$IFS"
      IFS='
'
      for del in $deleted; do
        # Generate custom command with source and dest placeholders replaced
        \echo  "$custom_string"
        custom_string=$( \echo "$custom_string" | \sed "s|<source>|${wd}/${left}|g; s|<dest>|${wd}/${del}|g" )
        \echo  "$custom_string"
        #\echo  "$custom_string" >> "$output_file"
      done
      IFS="$oldIFS"
      deleted=''
    ;;
  esac
done < "$input_fdupes_logfile"

echo "Generated output file: $output_file"
