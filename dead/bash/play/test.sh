# -----------------------------
until [ "sky" = "falling" ]; do
# -----------------------------

# Allow filenames with spaces.
#0=$IFS
#IFS=$(echo -en "\n\b")

# TODO: Deal with there being nothing in the directory.

rm -rf foo
mkdir foo
cd foo
get_contents() {
  for f in *; do
echo "$f"
    # build an array
  done
}
get_contents

test_get_contents() {
  echo .>file1
  mkdir dir1
  echo .>dir1/dir1-file1
}

#IFS=$0


#--------------------------------------------------------------------
break
done
#--------------------------------------------------------------------
: <<HERE_DOCUMENT

HERE_DOCUMENT
