# TODO:  Don't display the column header at all.
# TODO:  Place the cursor on / highlight the first menu entry:  'default'

result=$(
  \zenity \
    --list \
    --column="" \
    --title="Chromium" \
    --text="Select a profile" \
    "default" \
    "wow" \
    "p" \
  ` # `
)

if [[ $? -eq 0 ]]; then
  \nice -n 6 \chromium-browser --user-data-dir=/l/Chromium/$result &
fi
\echo $result
