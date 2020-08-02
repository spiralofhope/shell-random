#!/usr/bin/env  sh

# NOTE - POSIX shism



case $* in
  '')
    \echo  1
  ;;
  [0-9])
    \echo  0
  ;;
  [0-9][0-9])
    \echo  0
  ;;
  [-+][0-9]*[.][0-9]*)
    \echo  0
  ;;
  [0-9]*[.][0-9]*)
    \echo  0
  ;;
  [-+][0-9])
    \echo  0
  ;;
  ## shellcheck disable=2039
  ## shellcheck disable=2102
  [0-9]*[^^0-9])
    # FIXME? - In POSIX sh, ^ in place of ! in glob bracket expressions is undefined.
    # https://github.com/koalaman/shellcheck/wiki/SC2039
    \echo  0
  ;;
  *)
    \echo  1
  ;;
esac
