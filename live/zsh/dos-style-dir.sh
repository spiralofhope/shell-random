#!/usr/bin/env  zsh
# 
# zsh 5.7.1-1



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
  #originally:
  # Stopped working; was only showing the first word of a directory name
  #\ls  --almost-all  -l  --color=always | \grep ^d | \awk '{print $9}'

  :<<'  }'
    {
     # This just outputs everything as blue..
     # Works in Dash 0.5.10.2-5
    \tput  setaf  12  ;\
    \ls  -1  --directory  */  |\
      \sed  --expression='s/\/\/$//'  ;\
    \tput  sgr0
  }

  #:<<'  }'
  {
  # This outputs things in color, but doesn't have pagination
  # For pagination, one would have to manually do  `lsd | less`
  # Works in Dash 0.5.10.2-5
  # TODO - only symlinks leading to a directory
  for i in .* *; do
    if [ -d "$i" ] ||
       [ -L "$i" ]; then
      if    [ -d "$i" ]; then  \tput  setaf  12  ;  \echo  "$i"   #  blue
      elif  [ -L "$i" ]; then  \tput  setaf  14  ;  \echo  "$i"   #  cyan
      fi
    fi
  done
  # reset to normal
  \tput  sgr0
  }


  # An experiment to paginate
  :<<'  }'
  {
  # The array is a zshism
  # There's probably a bashism but I don't care enough to explore using Bash.
  array=
  for i in .* *; do
    if [ -d "$i" ] ||
       [ -s "$i" ]; then
      if    [ -d "$i" ]; then  \tput  setaf  12  ;  if [ -z "$array" ]; then  array="$i"  ;  else  array="$array$IFS$i"  ;  fi   #  blue
      elif  [ -s "$i" ]; then  \tput  setaf  14  ;  if [ -z "$array" ]; then  array="$i"  ;  else  array="$array$IFS$i"  ;  fi   #  cyan
      fi
    fi
  done
  \echo  $array | less
  # reset to normal
  \tput  sgr0
  unset  array
  }



}
alias ddir=lsd
lsda() {
  \ls  --almost-all  -l  --color=always | \grep ^d
}
