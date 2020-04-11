#!/usr/bin/env  sh
# Learn the difference in filesize between repository commits
# Modified from https://stackoverflow.com/a/10847242



# shellcheck disable=2034
# I don't actually understand how this all works..
USAGE='[--cached] [<rev-list-options>...]

Show file size changes between two commits or the index and a commit.

example of use:
'"$( \basename  "$0" )"'  HEAD~1  HEAD~2
'"$( \basename  "$0" )"'  --cached master
'



# shellcheck disable=1090
.  "$( \git  --exec-path )/git-sh-setup"
args=$( \git  rev-parse  --sq "$@" )
[ -n "$args" ] || usage



if [ "$1" = '--cached' ]; then
  cmd="diff-index"
else
  cmd="diff-tree -r"
fi
# shellcheck disable=1117
eval "\git $cmd $args" | {
  total=0
  while  \read  -r  A B C D M P; do
    case $M in
      M)  bytes="$(( $( \git  cat-file  -s "$D" ) - $( \git  cat-file  -s "$C" ) ))"  ;;
      A)  bytes="$(  \git cat-file -s "$D" )"  ;;
      D)  bytes="-$( \git cat-file -s "$C" )"  ;;
      *)
        \echo  >&2  "warning: unhandled mode $M in \"$A $B $C $D $M $P\""
        continue
      ;;
    esac
    total=$(( total + bytes ))
    \printf  '%d\t%s\n'  "$bytes"  "$P"
  done
  \echo  "total $total"
}
