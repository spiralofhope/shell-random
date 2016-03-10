#! /bin/sh

# This is a mount wrapper to remember the -o loop crap.
# See if $1 is an ISO and then just pass the right switches
# also use my new mount-root

# FIXME: This doesn't handle stupid mounting, like trying to mount a 
# PDF.  Hrmph.

until [ "sky" = "falling" ]; do

echo $#
  case "$#" in
    0)
      /bin/mount
      break
    ;;
    1)
      if [ "$1" = "-a" ]; then
        mount-root -a
        break
      else
        echo "Not valid"
        break
      fi
    ;;
    *)
      echo "Needs two parameters"
      break
      ;;
  esac
  EXT="${1##*.}"

  # I don't know if $@ is correct.  I want the expanded parameters to be double-quoted.
  # See http://zshwiki.org/home/docs/charindex for some possibilities.  Somewhere..
  if [ "$EXT" = "iso" ] || [ "$EXT" = "ISO" ]; then
    echo " # Mounting an ISO..."
    mount-root -o loop "$@" >/dev/null 2>&1
    # If it errored, run it again without blackholing it.
    if [ ! "$?" = "0" ]; then
      mount-root -o loop "$@"
    else
      echo "ok"
    fi
  else
    mount-root "$@" >/dev/null 2>&1
    # If it errored, run it again without blackholing it.
    if [ ! "$?" = "0" ]; then
      mount-root "$@"
    else
      echo "ok"
    fi
  fi

break
done # main loop
