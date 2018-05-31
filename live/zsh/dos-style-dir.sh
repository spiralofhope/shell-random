
# dir() { /bin/ls --color -gGh "$@"|cut -d" " -f4-100 ; }
# dir() { \ls --color -gGh "$@" | \cut -b14- | \less -F -r ; }
# Challenges:
# 1) Don't display a size for directories.
# TODO: -R does funny things.  Catch if it's been sent (even with -AR) and deal with it specially?
# Note that $LESS will influence the display.
:<<'}'   #  A proper dir command!
TODO_dir() {
  if [ "x$1" = "x-d" ] || [ "x$1" = "x-ad" ]; then
    ddir
    return $?
  fi
  file_sizes=
  file_sizes_commas=
  file_sizes_width=
  ls_options="-g  --no-group  -l  --numeric-uid-gid  -v  --color  --group-directories-first  ${@}"
  # FIXME: Why is the first file size left-aligned?
  # IDEA: Only display files.  I'd have to adapt the `find` code from ddir.

  # This will sort dotfiles above regular files.  Lubuntu 10.10 .. at first I needed it and now I don't.  Hrm.
  # export LANG="C"
# FUCK, fixme - doesn't work with stuff with spaces in it, or with directories with a space in them?  Or maybe directories with not much stuff in them..
  file_sizes=$(
    \ls $ls_options \
      | \cut  --bytes=15- \
      | \cut  --delimiter="-"  --fields=1 \
      | \rev \
      | \cut  --bytes=6- \
      | \sed  --expression='s/ //g' \
      | \rev
  )
  file_sizes_commas=comma( $file_sizes )
  file_sizes_width=$(
    \ls $ls_options \
      | \cut  --bytes=15- \
      | \cut  --delimiter="-" --fields=1 \
      | \rev \
      | \cut  --bytes=6- \
      | \sed  --expression='s/ //g' \
      | \rev \
      | \sort  --general-numeric-sort \
      | \sed  --expression=:a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta' \
      | \tail  --lines=1
  )
  file_sizes_width=${#file_sizes_width}
read -d '' file_sizes <<EOF
$(
  # Intentionally not in quotes.
  for i in $file_sizes_commas; do
    printf "%${file_sizes_width}s\n" "$i"
  done
)
EOF

  file_names=$(
    \ls $ls_options \
      | \cut  --bytes=15- \
      | \cut  --delimiter=":" --fields=2- \
      | \cut  --bytes=4- \
      | \sed  '1d'
  )
  # Yay for process substitution!  This puts the two columns side-by-side.
  \paste \
    <( \printf  '%s'  "$file_sizes" ) \
    <( \printf  '%s'  "$file_names" ) |\
      \less  --raw-control-chars  --HILITE-UNREAD  --QUIT-AT-EOF


#\echo "$new_file_sizes"
}



:<<'}'   #  DOS-style `dir /ad`
#  Stopped working
ddir() {
  OLD_LC_COLLATE="$LC_COLLATE"
  \export  LC_COLLATE=C
  if [ -z $1 ]; then
    \ls  -1  --color  --directory  *  .* | \less  --raw-control-char  --QUIT-AT-EOF

  else
    \ls  -1  --color  --directory  $*    | \less  --raw-control-char  --QUIT-AT-EOF
  fi
  \export  LC_COLLATE="$OLD_LC_COLLATE"
  OLD_LC_COLLATE=
}
lsd() {
  \ls  --almost-all  -l  --color=always | \grep ^d | \awk '{print $9}'
}
lsda() {
  \ls  --almost-all  -l  --color=always | \grep ^d
}
alias ddir=lsd
