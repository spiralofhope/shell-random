#!/usr/bin/env  sh



string_remove_whitespace_trailing() {
  string="$*"
  output=${string%${string##*[![:space:]]}}
  printf '%s\n' "$output"
}



string_remove_whitespace_trailing  "$*"
