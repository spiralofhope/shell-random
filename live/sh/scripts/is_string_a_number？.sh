#!/usr/bin/env  sh



case $* in
  '')
    return 1
  ;;
  [0-9])
    return 0
  ;;
  [0-9][0-9])
    return 0
  ;;
  [-+][0-9]*[.][0-9]*)
    return 0
  ;;
  [0-9]*[.][0-9]*)
    return 0
  ;;
  [-+][0-9])
    return 0
  ;;
  [0-9]*[^^0-9])
    # FIXME? - In POSIX sh, ^ in place of ! in glob bracket expressions is undefined.
    # https://github.com/koalaman/shellcheck/wiki/SC2039
    return 0
  ;;
  *)
    return 1
  ;;
esac
