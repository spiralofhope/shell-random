#!/usr/bin/env  sh


# Required programs:  dirname, grep, mkdir, sed, tail


logfile="$1"
output_file="$2"


_help() {
  echo "Generates a shell script to revert fdupes deletions by copying 'left' files to 'deleted' paths."
  echo "Usage: $0 <fdupes_log_file> <output_script> [--overwrite]"
  echo "  <fdupes_log_file>  Path to fdupes log file"
  echo "  <output_script>    Path to output shell script"
  echo "  --overwrite        Overwrite existing target files without prompting"
  return "$1"  2> /dev/null || { exit "$1"; }
}


# Sanity checking:
if [ "$1" = "--help" ]; then _help 0; fi
if [ -z "$*"         ]; then _help 1; fi
if [ ! -f "$logfile" ]; then
  echo "Error: Log file does not exist:"
  echo "$logfile"
  return 1  2> /dev/null || { exit 1; }
fi
if [ -z "$output_file" ]; then
  echo "Error: No output script specified:"
  echo "$output_file"
  return 1  2> /dev/null || { exit 1; }
fi


overwrite=0
if [ "$3" = "--overwrite" ]; then
  overwrite=1
fi

# Extract working directory from log
wd=$(grep -A1 "working directory:" "$logfile" | tail -1 | sed 's/^[ \t]*//')

# Initialize output script
echo "#!/usr/bin/env  sh" > "$output_file"
echo "# Script to revert fdupes deletions from $logfile" >> "$output_file"
echo "# Generated on $(date)" >> "$output_file"
echo "" >> "$output_file"

deleted=""
while IFS= read -r line; do
  case "$line" in
    deleted\ *)
      # Extract deleted file path
      del=$(echo "$line" | sed 's/^deleted //')
      if [ -z "$deleted" ]; then
        deleted="$del"
      else
        deleted="$deleted
$del"
      fi
      ;;
    *[[:blank:]]*left\ *)
      # Extract left file path
      left_line=$(echo "$line" | sed 's/^[ \t]*//')
      left=$(echo "$left_line" | sed 's/^left //')
      oldIFS="$IFS"
      IFS='
'
      for del in $deleted; do
        # Create directory for target file
        dir=$(dirname "$del")
        echo "mkdir -p \"$dir\"" >> "$output_file"
        if [ $overwrite -eq 1 ]; then
          # Copy without checking for existence
          echo "cp -a \"$wd/$left\" \"$wd/$del\"" >> "$output_file"
        else
          # Check if target exists and prompt
          echo "if [ -e \"$wd/$del\" ]; then" >> "$output_file"
          echo "  echo \"Target $del exists. Overwrite? (y/n)\"" >> "$output_file"
          echo "  read -r answer" >> "$output_file"
          echo "  if [ \"\$answer\" = \"y\" ] || [ \"\$answer\" = \"Y\" ]; then" >> "$output_file"
          echo "    cp -a \"$wd/$left\" \"$wd/$del\"" >> "$output_file"
          echo "  else" >> "$output_file"
          echo "    echo \"Skipping $del\"" >> "$output_file"
          echo "  fi" >> "$output_file"
          echo "else" >> "$output_file"
          echo "  cp -a \"$wd/$left\" \"$wd/$del\"" >> "$output_file"
          echo "fi" >> "$output_file"
        fi
      done
      IFS="$oldIFS"
      deleted=''
      ;;
  esac
done < "$logfile"

# Make output script executable
chmod +x "$output_file"
echo "Generated revert script: $output_file"
