spinner() {
  # Should implement sanity-checking then export this elsewhere so it can be universal.
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


booplay() {
  autoboo "/home/user/bin/boo/temp.txt"
}

EDITOR="/usr/bin/kwrite"
# EDITOR="/usr/bin/medit"
# Note that if medit is already playing, this isn't such a good idea because that process is running in the background and to the script it will seem as though it exited immediately.
# medit -n does not work.
# FIXME
BOO_EXEC="/home/user/live/application-testing/boo-0.9.1.3287-bin/bin/booc.exe"

: <<USAGE_NOTES

USE:  autoboo "filename"

Then script to your hearts content, and every time you save it, it'll be automatically run so you can make sure you're doing ok.

Perfect for people like me who save a *lot* but don't test enough. =)

*NOTE* This script will *not* remember or manipulate one's working directory.  SO, if your scripting moves you around, you'll *STAY MOVED AROUND*.  Update your scripting so it remembers and resets your location.

requirements:
- bash

This stuff is optional if you clean out that code.  Some of these tools can be obsoleted too.:
- kill
- grep
- hostname
- wmctrl

USAGE_NOTES

: <<TODO_LIST
- This script should remember the full path of the file specified.  Right now it doesn't, and if the scripting relocates the user, future attempts to source the script will fail!

- make sure $EDITOR exists, and is executable.
- watch for the end of the $EDITOR process
-- I could clean up temporary files or perform actions
-- then I could break out of this loop like a good puppy

- This script could also do fun stuff:
-- track the time spent.
-- track the number of saves (successes vs failures, and a ratio)

TODO_LIST

autoboo() {
  until [ "sky" = "falling" ]; do
    if [ "$1" = "" ]; then echo specify a file to watch ; break ; fi
    # TODO: Check parameters
    # I could be nice and accept lots of parameters and then generate a
    # file from that.  See renme
    # Also check to make sure it's a valid file
    # Also make sure that it's writable
    ## if not, try to make it writable and re-check
    nohup "$EDITOR" "$1" 2> /dev/null&
    # Capture the PID so I can know when the application has exited.
    EDITORPID=$!
    autoboo_run "$1"
    break
  done
}

autoboo_run() {
  FILE="$1"

  check_time() {
    # example:  -rw-rw-r-- 1 4 2009-03-29 13:34:56.000000000 -0700 /tmp/checkfile

#    # An eEarlier method, simplifying it to minimize processing power.
#    time=`ls -gG --full-time "$1" 2> /dev/null`
#    # example:  2009-03-29 13:34:56.000000000
#    time="${time:15:29}"
#    echo "$time"

    time=`ls -gG --full-time "$1" 2> /dev/null`
# bash
#    echo "${time:15:29}"
# zsh
    echo "${time[12,30]}"
  }

  run_rerun() {
    #clear
    # mono builds the executable in the current directory, so we have to fiddle about a bit.
    cd `dirname "$1"`
    echo "----------------" `date` "----------------"
    mono $BOO_EXEC $1 ; result=$?
    echo "--+ booc finished"
    # If it fails, re-run it with error checking!
    if [ $result -eq 0 ]; then
      # This match isn't too bright, but it ought to work for mono.
      mono ${1%.*}.exe
      echo "--+ mono finished"
      rm -f ${1%.*}.exe
      cd - > /dev/null
    # TODO: What kinds of exit codes should I be checking for?
    elif [ $result -eq 255 ] || [ $result -eq 127 ]; then
      # I have no clue how to re-run with way more verbosity.
      # Maybe I should use some kind of external debugger at this point?
      echo "---------------- Re-running: " `date` "----------------"
      # (enable debugging) - not sure how to do it better.  -debug+ is already default.
      echo "  .. with -ducky to be more forgiving."
      mono $BOO_EXEC "-ducky" $1 ; result=$?
      # (disable debugging)
    else
      echo "The exit code was $result"
    fi
  }

  time=`check_time "$FILE"`

  # When things start up, give it a go.
  # I don't want that, since I ^c out of bad scripts and don't want to begin autoboo again, and dive headlong into another bad script run.
  newtime=$time
  #run_rerun "$FILE"

  until [ "sky" = "falling" ]; do
    newtime=`check_time "$FILE"`
    if [ ! "$newtime" = "$time" ] && [ -s $FILE ]; then
      time=$newtime
      run_rerun "$FILE"
    fi

    # You could just do this, but I decided to be fancy and make a spinner!
    # echo "."

    # spinner: save cursor position
    echo -n -e "\033[s"
    spinner

    # I thought this would impact system performance, but it doesn't even register.  "ls" must really be smart!
    sleep 0.4s

    # kill can tell us if a pid exists or not.
    kill -0 $EDITORPID 2> /dev/null
      if [ $? != 0 ]; then
      echo "The editor exited.  This concludes autoboo."

# if I can figure out how to set the terminal title, I could match that with wmctrl and focus to it like so:
# wmctrl -F -a "$title"

      break
    fi
    # spinner: restore cursor position
    echo -n -e "\033[u"
  done
}
