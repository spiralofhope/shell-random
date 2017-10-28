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
    return 0
  ;;
  *)
    return 1
  ;;
esac
