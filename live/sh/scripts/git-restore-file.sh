_filename="$1"
_commit=` \git  rev-list  -n 1 HEAD  --  "$_filename" `
\git  checkout  "$_commit"^  --  "$_filename"
