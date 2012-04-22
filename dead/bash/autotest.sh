bashplay() {
  autotest /home/user/bin/bash/bashplay/temp.sh
}

EDITOR="/usr/bin/kwrite"

: <<USAGE_NOTES

USE:  autotest "filename"

Then script to your hearts content, and every time you save it, it'll be automatically run so you can make sure you're doing ok.

Perfect for people like me who save a *lot* but don't test enough. =)

*NOTE* This script will *not* remember or manipulate one's working directory.  SO, if your scripting moves you around, you'll *STAY MOVED AROUND*.  Update your scripting so it remembers and resets your location.

USAGE_NOTES

: <<TODO_LIST
- This script should remember the full path of the file specified.  Right now it doesn't, and if the scripting relocates the user, future attempts to source the script will fail!

- watch for the end of the $EDITOR process
-- I could clean up temporary files or perform actions
-- then I could break out of this loop like a good puppy

- This script could also do fun stuff:
-- track the time spent.
-- track the number of saves (successes vs failures, and a ratio)

TODO_LIST

autotest() {
  until [ "sky" = "falling" ]; do
    if [ "$1" = "" ]; then echo specify a file to watch ; break ; fi
    # TODO: Check parameters
    # I could be nice and accept lots of parameters and then generate a
    # file from that.  See renme
    # Also check to make sure it's a valid file
    # Also make sure that it's writable
    ## if not, try to make it writable and re-check

    nohup "$EDITOR" "$1" > /dev/null&
    autotest_run "$1"
    break
  done
}

autotest_run() {
  CHECKFILE="$1"

  # If the script is right here, then remember the full PWD too.
  # This is so that if the script being autotested does directory changing, then autotest can still find it to re-source it.
  # Note that this script doesn't bother resetting the user's location.  That would be interfering.
  if [ `dirname $CHECKFILE` = "." ]; then
    CHECKFILE="$PWD/$CHECKFILE"
  fi

  check_time() {
    # example:  -rw-rw-r-- 1 4 2009-03-29 13:34:56.000000000 -0700 /tmp/checkfile
    time=`ls -gG --full-time "$1" 2> /dev/null`
    # example:  2009-03-29 13:34:56.000000000
    time="${time:15:29}"
    echo "$time"
  }

  run_rerun() {
    #clear
    echo "----------------" `date` "----------------"
    source "$1"
    # If it fails, re-run it with error checking!
    if [ $? -ne 0 ]; then
      echo "---------------- Re-running: " `date` "----------------"
      # Technically I should remember and then restore it.
      set -x
      source "$1"
      set +x
    fi
  }

  spinner() {
    # TODO: I should implement sanity-checking then export this elsewhere so it can be universal.
    if [ "$spinner" = "" ]; then spinner=0 ; fi
    # traditional bar-spinner: -\|/
    case "$spinner" in
      0)
        printf '-'
        ((spinner++))
      ;;
      1)
        printf '\'
        ((spinner++))
      ;;
      2)
        printf '|'
        ((spinner++))
      ;;
      3)
        printf '/'
        ((spinner++))
      ;;
      4)
        printf '-'
        spinner=1
      ;;
      *)
        echo Spinner error!
      ;;
    esac
  }

  time=`check_time "$CHECKFILE"`

  # When things start up, give it a go.
  run_rerun "$CHECKFILE"

  until [ "sky" = "falling" ]; do
    newtime=`check_time "$CHECKFILE"`
    if [ ! "$newtime" = "$time" ]; then
      time=$newtime
      run_rerun "$CHECKFILE"
    fi

    # You could just do this, but I decided to be fancy and make a spinner!
    # echo "."

    # spinner: save cursor position
    echo -n -e "\033[s"
    spinner

    # I thought this would impact system performance, but it doesn't even register.  "ls" must really be smart!
    sleep 0.4s

    # spinner: restore cursor position
    echo -n -e "\033[u"
  done
}
