# With thanks to
#   https://unix.stackexchange.com/questions/46276/



while IFS= read -d '' -r file; do
  [[ "$(file -b --mime-encoding "$file")" = binary ]] &&
    { echo "Skipping   $file"; continue; }

  echo "Processing $file"
  \mv  "$file"  BAD/

  # ...

done < <(find . -type f -print0)
