#!/usr/bin/env zsh

todo() {
# TODO: Distinctly identify debugging vs regular.  Maybe a simple colour change, or some text..?

: <<TODO_LIST
Also search this script for 'TODO:' and 'FIXME:'

- host on github

- Implement versioning and a changelog.

- Check all requirements in some way that doesn't require 'which'

- Should I allow extensions like .bash or .zsh?

- make sure that $EDITOR exists, and is executable.

- This script could also do fun stuff:
-- track the time spent.
-- track the number of saves (successes vs failures, and a ratio)
- I could spawn another process which will do the spinner activity and watch for the editor exit.  This could be thrown into a nice terminal window, a dialog/zenity dialogue or even a tray icon.

- Consider making an autotest.sh.ini file to make things more user-serviceable.

- Perhaps separate out all the specific filetype handling stuff into separate .sh or .ini files?  I don't know if that would actually make things more maintainable..
TODO_LIST
}

user_preferences() {
  # Uncomment if you do not have an ANSI-capable terminal.
  # ANSI="no"

  # Uncomment this if you don't want to have the timing of your script execution.
  # DATE="no"
  # Uses GNU coreutils' `date`
  # http://www.gnu.org/software/coreutils/manual/coreutils.html#date-invocation
  # Note that this might be replacable with `time`, which gives more info.
  # readlink
  # basename
  # TODO: I don't need basename if I just script it separately in zsh/bash..

  # EDITOR="/usr/bin/kwrite"
  #EDITOR="/usr/bin/mousepad"
  #EDITOR2="/usr/bin/geany"
  # EDITOR="/usr/bin/medit"
  # Note that if medit is already running in the background, to this script it will seem as though it exited immediately.
  # medit -n does not work.
  # TODO: Is there some way to force a process to the foreground?

  # Uncomment this if you want to clear the terminal output each time your script is re-run.
  # CLEAR_SCREEN="yes"

  # Uncomment this if you want this script to 'cd' into the directory your script resides in, each time it is run.
  # If not set, this script will 'cd' into your current working directory ($PWD) each time your script is run.
  # CD_SCRIPTDIR="yes"

  # How long should the main loop routine wait before re-checking for a file change?
  # I thought this would impact system performance, but it doesn't even register.  "ls" must really be smart!
  # Change this if you need to!
  SLEEP="0.4s"

  # Uncomment if you don't want your script execution timed.
  # TIME="no"

  # Regularly re-check the file's permissions, to notice and attempt to correct permissions issues.
  # This may impact system performance.  If you suspect this, then uncomment this.
  # AGGRESSIVE_CHECK_AUTOTEST_FILE="no"
}
user_preferences

usage() {
\cat <<'HEREDOC'
USE:
autotest "filename"
autotest /path/to/file.sh

switches:
-bg         some sort of background thingy (to re-test)
--nodebug   do not re-run if a non-0 exit code is returned from the first run

Supported file types:
.sh  - bash, zsh
  http://www.gnu.org/software/bash/bash.html
  http://www.zsh.org/
.boo - boo programming language
  http://boo.codehaus.org/
.my  - Mythryl programming language
  http://mythryl.org/
  With this script, the top shebang is optional.
.py  - Python programming language
  http://www.python.org/
.rb  - Ruby programming language
  http://ruby-lang.org/
.rb  - Ruby programming language using the Shoes GUI toolkit with a .rb extension
  http://ruby-lang.org/
  http://shoesrb.com/
.shy - Ruby programming language, Shoes GUI toolkit
  http://ruby-lang.org/
  http://shoesrb.com/
Note that other programming languages won't be too hard to add.

Then script to your heart's content, and every time you save it,
it'll be automatically run so you can make sure you're doing ok.

Perfect for people like me who save a *lot* but don't test enough. =)

Requirements:  (all of which should be on all systems)
1. Either 'bash' or 'zsh'.  Other shells can be programmed for.
    http://www.gnu.org/software/bash/bash.html
    http://www.zsh.org/
    TODO:  This could be made POSIX and universally runnable.
      get_file_time() and execute_with_debugging() are shell-specific.
2. GNU coreutils
    http://www.gnu.org/software/coreutils/manual/coreutils.html
    'basename'
      http://www.gnu.org/software/coreutils/manual/coreutils.html#basename-invocation
        Alternates: 'cut' or with shell functionality.
    `cat`
      http://www.gnu.org/software/coreutils/manual/coreutils.html#cat-invocation
        Alternates: Probably shell functionality.  Perhaps just zsh.
    `cut`
      http://www.gnu.org/software/coreutils/manual/coreutils.html#cut-invocation
      I used to be able to do this with bash/zsh internals, but now it's not possible.  Odd.
    `dirname`
        http://www.gnu.org/software/coreutils/manual/coreutils.html#dirname-invocation
        Alternates: 'cut' or with shell functionality.
    `grep`
        Alternates: Probably zsh shell functionality.
    `nohup`
        http://www.gnu.org/software/coreutils/manual/coreutils.html#nohup-invocation
        I don't think there are alternatives.  I tried some other methods, but they don't seem to work.
    `readlink`
        http://www.gnu.org/software/coreutils/manual/coreutils.html#readlink-invocation
        Alternates:  'ps', or some funky scripting to check /proc
    `sleep`
        http://www.gnu.org/software/coreutils/manual/coreutils.html#sleep-invocation
        Alternates:  Shell functionality or another program/method.

TODO:  `head` is used by .my

`chmod`

HEREDOC
}

setup() {
  MYSHELL=$( \basename $( \readlink /proc/$$/exe ) )
  ORIGINAL_PWD="$PWD"
  \source /l/Linux/bin/zsh/colours.sh
}
setup

spinner() {
  if [ -z $SPINNER ]; then return 0 ; fi
  # FIXME?  This doesn't handle a resized terminal window very well.  It should re-check / re-set its position somehow.
  # TODO: Implement sanity-checking then export this elsewhere so that this code can be used elsewhere.
  # Traditional bar-spinner with these characters: -\|/
  # Another idea:  .oO0Oo
  # I could use printf, but I'd rather use echo.
  case $SPINNER in
    0)
      \echo -e -n "${cursor_position_save}${green}\055${reset}${cursor_position_restore}"
      SPINNER=1
    ;;
    1)
      # CHECKME: One backslash was causing issues with syntax colouring.  Hopefully this works..
      \echo -e -n "${cursor_position_save}${green}\\${reset}${cursor_position_restore}"
      SPINNER=2
    ;;
    2)
      \echo -e -n "${cursor_position_save}${green}|${reset}${cursor_position_restore}"
      SPINNER=3
    ;;
    3)
      \echo -e -n "${cursor_position_save}${green}/${reset}${cursor_position_restore}"
      SPINNER=0
    ;;
    *)
      echo "${red}Odd error, SPINNER was out of range:${reset} \"${SPINNER}\"${cursor_position_save}"
      SPINNER=0
      spinner
    ;;
  esac
  # Restore the colour in case there is some output that interrupts the spinner.
  # TODO: Figure out how to save the original foreground/background colours and restore them here..
  \echo -e -n ${reset}
}

ansi_echo() {
  STRING="$1"
  if [ "$ANSI" = "no" ]; then
    \echo $STRING
  else
    # Note that this assumes you have light grey as your default text.  That's the end part after $STRING and before the final \n
    \echo -e "\x1b\x5b1;33;40m$STRING\x1b\x5b0;37;40m\n"
  fi
}

check_file() {
  # TODO: Allow parameters to be passed to only perform certain checks.  Then export this to make it a universal procedure.
  #   Then also have specific error codes for failing to correct certain checks.
  AUTOTEST_FILE="$1"
  until [ ! -d "$AUTOTEST_FILE" ] && [ "$AUTOTEST_FILE" != "" ] ; do
    \echo "That is a directory:  $AUTOTEST_FILE"
    # TODO:  Implement a file lister to choose another file - there's the zsh file lister I have somewhere around here...
    \echo "Type the name of the file to use, or ^c to abort:  "
    \echo -n "> "
    \read AUTOTEST_FILE
    trap "{ \echo 'Aborting.' ; return 1 ; }" SIGINT SIGTERM
  done
  if [ ! -e "$AUTOTEST_FILE" ]; then
    \echo "File doesn't exist:  $AUTOTEST_FILE"
    \echo -n "Shall I create it? [Y/n]  "
    \read ANSWER
    if [ "$ANSWER" = "" ] || [[ "$ANSWER" =~ "^(y)" ]]; then
      \echo>"$AUTOTEST_FILE" ; RESULT=$?
      if [ ! -e "$AUTOTEST_FILE" ] || [ $RESULT -ne 0 ] ; then
        \echo "There were issues creating the file.  Aborting."
        return 1
      fi
    else
      \echo "Opted to not create the file.  Aborting."
      return 1
    fi
  fi
  # The file does exist.
  # Readable?
  if [ ! -r "$AUTOTEST_FILE" ]; then
    \echo "The file isn't readible.  Trying to correct that."
    \chmod u+r "$AUTOTEST_FILE" ; RESULT=$?
    if [ $RESULT -ne 0 ]; then
      \echo "I couldn't correct that.  Aborting."
      return 1
    else
      \echo "It looks like it worked."
    fi
  fi
  # Writable?
  if [ ! -w "$AUTOTEST_FILE" ]; then
    \echo "The file isn't writable.  Trying to correct that."
    \chmod u+w "$AUTOTEST_FILE" ; RESULT=$?
    if [ $RESULT -ne 0 ]; then
      \echo "I couldn't correct that.  Aborting."
      return 1
    else
      \echo "It looks like it worked."
    fi
  fi
  # Executable?
  if [ ! -x "$AUTOTEST_FILE" ]; then
    \echo "The file isn't executable.  Trying to correct that."
    \chmod u+x "$AUTOTEST_FILE" ; RESULT=$?
    if [ $RESULT -ne 0 ]; then
      \echo "I couldn't correct that.  Aborting."
      return 1
    else
      \echo "It looks like it worked."
    fi
  fi
  # If we survived this, then the file seems to be sane.
  return 0
}

get_file_ext() {
  AUTOTEST_FILE="$1"
  AUTOTEST_DIR=`dirname "$AUTOTEST_FILE"`
  # 1.tar.bz2 => tar.bz2 (good, but...)
  #   it also does 1.test.test.tar.bz2 => test.test.tar.bz2 (bad idea!)
  # EXT=${AUTOTEST_FILE#*.}
  # 1.tar.bz2 => bz2 (better!)
  # Is this problematic code for other shells?
  EXT=${AUTOTEST_FILE##*.}
  # Something like this is possible with zsh, but I never figured it out:
  #EXT=${AUTOTEST_FILE:t}

  #Based on the extension, set up the pre/post execution routines.
  case "$EXT" in
    "boo") # Boo programming language
      # I know this looks convoluted, but booc cannot be sent a non-useful parameter (unset/empty, or a blank space, etc)
      DUCKY="$AUTOTEST_FILE"
      execute() {
        \booc "$DUCKY" ; RESULT="$?"
        ansi_echo "--+ booc finished"
        # Since problems can arise with booc, the mono execution should be smart.
        if [ "$RESULT" = "0" ]; then
          \mono ${AUTOTEST_FILE%.*}.exe ; RESULT="$?"
          ansi_echo "--+ mono finished"
          \rm -f ${AUTOTEST_FILE%.*}.exe
        fi
      }
      execute_with_debugging() {
        if [ "$RESULT" = "255" ] || [ "$RESULT" = "127" ]; then
          DUCKY="$AUTOTEST_FILE -ducky"
          execute
        else
          ansi_echo "I don't know what to do with that exit code:  $RESULT"
        fi
      }
      return 0
    ;;
    "py") # Python programming language
      execute() {
        \python "$AUTOTEST_FILE" ; RESULT="$?"
      }
      execute_with_debugging() {
        \python -d "$AUTOTEST_FILE" ; RESULT="$?"
      }
      return 0
    ;;
    "rb") # Ruby programming language
      # Check if it's a shoes script
      \cat "$AUTOTEST_FILE" | \grep -q "Shoes.app" ; RESULT="$?"
      if [ $RESULT = 1 ]; then
        # Ruby programming language
        execute() {
          \ruby "$AUTOTEST_FILE" ; RESULT="$?"
        }
        execute_with_debugging() {
          if [ "x${DEBUG}" != "xfalse" ]; then
            \ruby --debug "$AUTOTEST_FILE" ; RESULT="$?"
          fi
        }
      else
        # Ruby programming language, Shoes GUI toolkit
        execute() {
          ~/shoes/dist/shoes "$AUTOTEST_FILE" ; RESULT="$?"
        }
        execute_with_debugging() {
          ~/shoes/dist/shoes "$AUTOTEST_FILE" ; RESULT="$?"
        }
      fi
      return 0
    ;;
    "shy") # Ruby programming language, Shoes GUI toolkit
      execute() {
        ~/shoes/dist/shoes "$AUTOTEST_FILE" ; RESULT="$?"
      }
      execute_with_debugging() {
        ~/shoes/dist/shoes "$AUTOTEST_FILE" ; RESULT="$?"
      }
      return 0
    ;;
    "my") # Mythryl programming language
      execute() {
        #/usr/bin/mythryl: '/mnt/ssd/projects/mythryl/tutorial.my' is not a valid script!
        #/usr/bin/mythryl should only be invoked via ''#!...'' line in a script!
        #/usr/bin/mythryl "$AUTOTEST_FILE" ; RESULT="$?"
        # Check for the shebang
        local head="`\head --lines=1 \"$AUTOTEST_FILE\"`"
        local mythryl_shebang="#!/usr/bin/mythryl"
        if ! [[ $head == $mythryl_shebang ]]; then
          #\echo "no shebang?"
          # No shebang?  Add one.
          # Also add braces, since I was probably lazy about that.
          # TODO:  Check if I already had braces?  Meh.
          local mythryl_file="${AUTOTEST_DIR}/mythryl_shebanged.my"
          \echo $mythryl_shebang > $mythryl_file
          \echo                 >> $mythryl_file
          \echo "{"             >> $mythryl_file
          \cat "$AUTOTEST_FILE" >> $mythryl_file
          \echo                 >> $mythryl_file
          \echo "};"            >> $mythryl_file
          \chmod +x $mythryl_file
          "$mythryl_file" ; RESULT="$?"
          \rm --force $mythryl_file
        else
          #\echo "found a shebang"
          "$AUTOTEST_FILE" ; RESULT="$?"
        fi

        # I can't fathom why they throw 1 on success and 0 on failure.
        if [ $RESULT = 1 ]; then
          RESULT=0
        else
          if [ $RESULT = 0 ]; then
            RESULT=1
          fi
        fi
        # Since I can't figure debugging out, I'm going to hard-code success.
        RESULT=0
        \rm --force \
          "$AUTOTEST_DIR"/main.log~ \
          "$AUTOTEST_DIR"/mythryl.COMPILE_LOG \
          "$AUTOTEST_DIR"/read-eval-print-loop.log~
      }
      execute_with_debugging() {
        # TODO:  Deal with the shebang issue here too, when I figure debugging out.
        "$AUTOTEST_FILE"

        \echo "TODO: I don't know how to invoke debugging, if such a thing exists."
        # These aren't actually useful.
        #\cat "$AUTOTEST_DIR"/main.log~
        #\cat "$AUTOTEST_DIR"/read-eval-print-loop.log~
        \rm --force \
          "$AUTOTEST_DIR"/main.log~ \
          "$AUTOTEST_DIR"/read-eval-print-loop.log~
      }
      return 0
    ;;
    "sh") # *nix shell scripting languages
      if [ "x$MYSHELL" = "xzsh4" ]; then MYSHELL="zsh"; fi
      case "$MYSHELL" in
        "bash")
          execute() {
            source "$AUTOTEST_FILE" ; RESULT="$?"
          }
          execute_with_debugging() {
            # TODO: I should remember and then restore it, but how?
            set -x
            execute
            set +x
          }
        ;;
        "zsh")
          execute() {
            source "$AUTOTEST_FILE" ; RESULT="$?"
          }
          execute_with_debugging() {
            # TODO: I should remember and then restore it, but how?
            setopt xtrace
            execute
            unsetopt xtrace
          }
        ;;
        *)
          \echo ""
          ansi_echo "ERROR:  Your shell is not supported:  $MYSHELL"
          \echo "Don't fret, it's not too hard to hack this script to add functionality."
          \echo "To add support, edit this script and:"
          \echo "  1. Search for this error message and edit this code."
          \echo "  2. Also search for "\''case "$MYSHELL" in'\'" and edit that code."
          \echo ""
          break
      esac
      return 0
    ;;
    *)
      \echo ""
      ansi_echo "ERROR:  Your file type is not supported:  $EXT"
      \echo "Don't fret, it's not too hard to hack this script to add functionality."
      \echo "To add support, edit this script and search for this error message."
      \echo ""
      # TODO: Peek in and check the first line for a shebang that's supported.  That would be a good way to at least warn when in one shell but executing a script meant for another shell.  Maybe even switch to that shell to run the script?  i.e. if in zsh, and there is #!/bin/bash at the top, then do:  execute() { "bash $AUTOTEST_FILE" ; RESULT="$?" }
      # head -n 1 "$AUTOTEST_FILE"
      # Use sed/whatever else?
      return 1
  esac
  return 0
}

get_file_time() {
  AUTOTEST_FILE="$1"
  AUTOTEST_FILE_TIME=""
  # AUTOTEST_FILE_TIME_TEMP="-rw-rw-r-- 1 4 2009-03-29 13:34:56.000000000 -0700 /tmp/checkfile"
  # AUTOTEST_FILE_TIME="2009-03-29 13:34:56.000000000"
  AUTOTEST_FILE_TIME_TEMP=`ls --full-time -gG --no-group "$AUTOTEST_FILE"`

  case "$MYSHELL" in
    "bash")
      # For reasons unknown, this doesn't work anymore.
      # AUTOTEST_FILE_TIME="${AUTOTEST_FILE_TIME_TEMP:15:29}"
      AUTOTEST_FILE_TIME=`\echo "$AUTOTEST_FILE_TIME_TEMP"|"cut" --delimiter " " --fields 4,5`
    ;;
    "zsh")
      # For reasons unknown, this doesn't work anymore.
      # AUTOTEST_FILE_TIME="${AUTOTEST_FILE_TIME_TEMP[12,30]}"
      AUTOTEST_FILE_TIME=`\echo "$AUTOTEST_FILE_TIME_TEMP"|"cut" --delimiter " " --fields 4,5`
    ;;
    *)
      # Other shells might/should be able to use an external program like 'cut', or some other "real" programming language (Perl, Python, Ruby, etc)
      AUTOTEST_FILE_TIME=`\echo "$AUTOTEST_FILE_TIME_TEMP"|"cut" --delimiter " " --fields 4,5`
  esac
}

run_script() {
  AUTOTEST_FILE="$1"
  RESULT=0

  run_script_main() {
    if [ "$RESULT" != "0" ] && [ "x${DEBUG}" != "false" ]; then
      # nothing
    else
      AUTOTEST_FILE="$1"
      if [ "$CLEAR_SCREEN" = "yes" ]; then clear; fi
      if [ "$CD_SCRIPTDIR" = "yes" ]; then
        \cd `"dirname" "$AUTOTEST_FILE"`
      else
        \cd "$ORIGINAL_PWD"
      fi

      if [ ! "$TIME" = "no" ]; then
        # TODO : use 'time' to time it.  I'm not sure how, since I want to grab the result from the original program.
        TIMESTAMP_BEGIN=`date +%s`
      fi
      ansi_echo "--+ begin" `date` "+--"

      if [ "$RESULT" = "0" ]; then
        execute
      else
        execute_with_debugging
      fi

      ansi_echo "--+ end [$RESULT]" `date` "+--"
      if [ ! "$TIME" = "no" ]; then
        TIMESTAMP_END=`date +%s`
        \echo "$(($TIMESTAMP_END - $TIMESTAMP_BEGIN)) seconds"
        # TODO: Detect if it's appropriate to list in minutes, then display in mm:ss
        #   Maybe also do hh:mm:ss, oh hell.. do yy:dd:mm:ss for kicks!
      fi
      # Give a little breathing room, so you can see better.
      \echo ""
      \echo ""
    fi
  }

  run_script_main "$AUTOTEST_FILE"
  # If it fails, re-run it.
  # It'll see the non-zero $RESULT and run execute_with_debugging
  if [ ! "$RESULT" = "0" ]; then run_script_main "$AUTOTEST_FILE" ; fi
}

main_foreground() {
  until [ "MAIN_ROUTINE" = "finished" ]; do
    AUTOTEST_FILE=$( \readlink --canonicalize "$1" )

    check_file "$AUTOTEST_FILE"
    if [ ! $? = "0" ]; then break ; fi

    get_file_ext "$AUTOTEST_FILE"
    if [ ! $? = "0" ]; then break ; fi

    get_file_time "$AUTOTEST_FILE"
    if [ ! $? = "0" ]; then break ; fi

    NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"

    # Launch the editor
  #   "nohup" "$EDITOR" "$AUTOTEST_FILE" 2>/dev/null& ; RESULT="$?"
    #\exec "$EDITOR" "$AUTOTEST_FILE" &
    # Fuck the configurability, let's do this manually..
    \geany --new-instance "$AUTOTEST_FILE" &
    RESULT="$?"
    if [ ! "$RESULT" = "0" ]; then
      \echo "Unable to launch editor:  $EDITOR"
      return 1
    fi
    # Capture the PID so I can know when the application has exited.
    EDITORPID=$!
    #exec "$EDITOR2" "$AUTOTEST_FILE" &

    # ----
    # Main Routine:  The file change checking loop
    # ----
    # Note that I'm still in MAIN_ROUTINE.  This is so that all the earlier procedures can still be relied upon to break out of the whole script, even during operation.  This is a good idea in case things go awry during operation (permissions change, the filesystem unmounts, etc).

    until [ "MAIN_ROUTINE_LOOP" = "finished" ]; do

    # Check the file
    # This is run every iteration of the main loop to see if the fundamental permissions of the script being edited change during operation.
      if [ ! "$AGGRESSIVE_CHECK_AUTOTEST_FILE" = "no" ]; then
       check_file "$AUTOTEST_FILE"
        if [ $? -ne 0 ]; then \echo "check_file failed, aborting" ; break ; fi
      fi

      # Status
      if [ "$ANSI" = "no" ]; then
        \echo "."
        "sleep" "$SLEEP"
      else
        # spinner: save cursor position
        \echo -n -e "\033[s"
        spinner
        "sleep" "$SLEEP"
        # spinner: restore cursor position
        \echo -n -e "\033[u"
      fi

      # Check to see if the file has changed.  If so, run it.
      get_file_time "$AUTOTEST_FILE"
      if [ ! "$NEW_AUTOTEST_FILE_TIME" = "$AUTOTEST_FILE_TIME" ] && [ -s "$AUTOTEST_FILE" ]; then
        NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"
        run_script "$AUTOTEST_FILE"
      fi

      # Is the editor is still running?
      # I could have used kill, but I prefer readlink because it's smaller.
      # kill -0 $EDITORPID 2> /dev/null
      # Interesting how --quiet and --silent don't work, and the name of the executable keeps being echoed on each iteration.  I wonder if this is a bug, because it's certainly unexpected.  But then again, GNU is all about difficult programs with unexpected results.  They are generally anti-POLS (principle of least surprise).
      \readlink /proc/"$EDITORPID"/exe > /dev/null ; RESULT="$?"
      if [ ! "$RESULT" = "0" ]; then
        ansi_echo "The editor exited.  This concludes autotest."
        # TODO:  If I can figure out how to set the terminal title, I could match that with wmctrl and focus to it like so:
        # wmctrl -F -a "$title"
        # TODO:  I could clean up temporary files or perform actions.  Implement a per-language cleanup.
        break # MAIN_LOOP
      fi
    done

    break # MAIN_ROUTINE
  done
}
main_background() {
  PID_FILE="$TMP/$( \basename "$0" )".$$.lock
  \echo . >> "$PID_FILE"

  check_file "$AUTOTEST_FILE"
  if [ ! $? = "0" ]; then break ; fi
  # Launch it automatically.
  run_script "$AUTOTEST_FILE"

#-----------

  until [ "MAIN_ROUTINE" = "finished" ]; do
    AUTOTEST_FILE=$( \readlink --canonicalize "$1" )

    check_file "$AUTOTEST_FILE"
    if [ ! $? = "0" ]; then break ; fi

    get_file_ext "$AUTOTEST_FILE"
    if [ ! $? = "0" ]; then break ; fi

    get_file_time "$AUTOTEST_FILE"
    if [ ! $? = "0" ]; then break ; fi

    NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"

    # ----
    # Main Routine:  The file change checking loop
    # ----
    # Note that I'm still in MAIN_ROUTINE.  This is so that all the earlier procedures can still be relied upon to break out of the whole script, even during operation.  This is a good idea in case things go awry during operation (permissions change, the filesystem unmounts, etc).
    until [ "MAIN_ROUTINE_LOOP" = "finished" ]; do

    # Check the file
    # This is run every iteration of the main loop to see if the fundamental permissions of the script being edited change during operation.
      if [ ! "$AGGRESSIVE_CHECK_AUTOTEST_FILE" = "no" ]; then
       check_file "$AUTOTEST_FILE"
        if [ $? -ne 0 ]; then \echo "check_file failed, aborting" ; break ; fi
      fi

      # Check to see if the file has changed.  If so, run it.
      get_file_time "$AUTOTEST_FILE"
      if [ ! "$NEW_AUTOTEST_FILE_TIME" = "$AUTOTEST_FILE_TIME" ] && [ -s "$AUTOTEST_FILE" ]; then
        NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"
        run_script "$AUTOTEST_FILE"
      fi

      if [ ! -f $PID_FILE ]; then
        break # MAIN_LOOP
      fi

    done

    break # MAIN_ROUTINE
  done
}

# TODO:  No spinner
main() {
if [ -z $1 ]; then
  usage
  return 0
fi
if [ "x${2}" = "x" ]; then
  SPINNER=0
  main_foreground $@
elif [ "x${2}" = "x-bg" ]; then
  SPINNER=0
  main_background $@
elif [ "x${2}" = "x--nodebug" ]; then
  SPINNER=0
  DEBUG="false"
  main_foreground $@
else
  usage
  return 1
fi
}
main $@
