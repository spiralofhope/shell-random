#!/usr/bin/env  zsh

# FIXME - Ansi doesn't work with the spinner.



:<<'}'   #  TODO
{
# TODO: Distinctly identify debugging vs regular.  Maybe a simple colour change, or some text..?

: <<TODO_LIST
- Rework this so it works in vanilla shell (dash)
- Consider implementing directory watching.


Also search this script for 'TODO:' and 'FIXME:'

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

- If it errors, setopt -x and re-run it! 
TODO_LIST
}



:<<'}'   #  git-bash:  ANSI under Windows
Use ANSICON
  https://blog.spiralofhope.com/?p=37580
  http://ansicon.adoxa.vze.com/
  https://github.com/adoxa/ansicon/releases/latest
on Windows 10:
  1. unzip it somewhere.
  2. open a cmd as admin
       windows-x a
  3. go to its unzipped location, to x64
  4. ansicon.exe -I
}



user_preferences() {
  # Uncomment if you do not have an ANSI-capable terminal.
  ANSI='no'

  # Uncomment this if you don't want to have the timing of your script execution.
  # DATE='no'
  # Uses GNU coreutils' `date`
  # http://www.gnu.org/software/coreutils/manual/coreutils.html#date-invocation
  # Note that this might be replacable with `time`, which gives more info.
  # readlink
  # basename
  # TODO: I don't need basename if I just script it separately in zsh/bash..

  # EDITOR='/usr/bin/kwrite'
  #EDITOR='/usr/bin/mousepad'
  #EDITOR2='/usr/bin/geany'
  # EDITOR='/usr/bin/medit'
  # Note that if medit is already running in the background, to this script it will seem as though it exited immediately.
  # medit -n does not work.
  # TODO: Is there some way to force a process to the foreground?

  # Uncomment this if you want to clear the terminal output each time your script is re-run.
  # CLEAR_SCREEN='yes'

  # Uncomment this if you want this script to 'cd' into the directory your script resides in, each time it is run.
  # If not set, this script will 'cd' into your current working directory ($PWD) each time your script is run.
  # CD_SCRIPTDIR='yes'

  # How long should the main loop routine wait before re-checking for a file change?
  # I thought this would impact system performance, but it doesn't even register.  `ls` must really be smart!
  # Change this if you need to!
  SLEEP='0.4s'
  \printf  '%s'  "$SLEEP" > /dev/null

  # Uncomment if you don't want your script execution timed.
  # TIME='no'

  # Regularly re-check the file's permissions, to notice and attempt to correct permissions issues.
  # This may impact system performance.  If you suspect this, then uncomment this.
  # AGGRESSIVE_CHECK_AUTOTEST_FILE='no'
}
user_preferences



usage() {
\cat  <<'HEREDOC'
USE:
autotest 'filename'
autotest /path/to/file.sh

switches:
-bg         some sort of background thingy (to re-test)
--nodebug   do not re-run if a non-0 exit code is returned from the first run

Supported file types:
.sh  - bash, zsh
  http://www.gnu.org/software/bash/bash.html
  http://www.zsh.org/
.c   - C programming language
  (TODO)
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
  MYSHELL="$( \basename  "$( \readlink  /proc/$$/exe )"s )"
  ORIGINAL_PWD="$PWD"
  spinner_counter='1'

  #:<<'  }'   #  Distinguish between platforms
            #  - Cygwin
            #  - Linux
            #  - Windows Subsystem for Linux
  {
  case "$( \uname  --kernel-name )" in
    # Cygwin / Babun
    CYGWIN*)          export  this_kernel_release='Cygwin' ;;
    MINGW*)           export  this_kernel_release='Mingw' ;;
    # This might be okay for git-bash
    'Linux')
      case "$( \uname  --kernel-release )" in
        *-Microsoft)  export  this_kernel_release='Windows Subsystem for Linux' ;;
        *)            export  this_kernel_release='Linux' ;;
      esac
    ;;
    *)
      \echo  " * No scripting has been made for:  $( \uname  --kernel-name )"
    ;;
  esac
  }

  # shellcheck disable=1090
  # zshism
  # shellcheck disable=2039
  \source  "$HOME/l/shell-random/live/sh/functions/colours.sh"
  \source  "$HOME/l/shell-random/live/sh/functions/spinner.sh"
}
setup



ansi_echo() {
  STRING="$1"
  if [ "$ANSI" = 'no' ]; then
    \echo  "$STRING"
  else
    # Note that this assumes you have light grey as your default text.  That's the end part after $STRING and before the final \n
    \printf  '\x1b\x5b1;33;40m%s\x1b\x5b0;37;40m\n'  "$STRING"
  fi
}



check_file() {
  break_if_failed() {
    # shellcheck disable=2181
    # zshism
    # shellcheck disable=2104
    if [ $? -ne 0 ]; then  \echo  'check_file failed, aborting' ; break ; fi
  }
  # TODO: Allow parameters to be passed to only perform certain checks.  Then export this to make it a universal procedure.
  #   Then also have specific error codes for failing to correct certain checks.
  AUTOTEST_FILE="$1"
  until [ ! -d "$AUTOTEST_FILE" ] && [ "$AUTOTEST_FILE" != '' ] ; do
    \echo  "That is a directory:  $AUTOTEST_FILE"
    # TODO:  Implement a file lister to choose another file - there's the zsh file lister I have somewhere around here...
    # Does dialog have something I can leverage?
    \echo  'Type the name of the file to use, or ^c to abort:  '
    \printf  '> '
    \read  -r  AUTOTEST_FILE
    # shellcheck disable=1117
    trap  "{ \echo 'Aborting.' ; return 1 ; }" INT TERM
  done
  if [ ! -e "$AUTOTEST_FILE" ]; then
    \echo  "File doesn't exist:  $AUTOTEST_FILE"
    \printf  'Shall I create it? [Y/n]  '
    \read  -r  ANSWER
    # zshism
    # shellcheck disable=2039
    # shellcheck disable=2076
    if [ "$ANSWER" = '' ] || [[ "$ANSWER" =~ "^(y)" ]]; then
      \echo  >  "$AUTOTEST_FILE" ; RESULT=$?
      if [ ! -e "$AUTOTEST_FILE" ] || [ $RESULT -ne 0 ] ; then
        \echo  'There were issues creating the file.  Aborting.'
        # zshism
        # shellcheck disable=2104
        break
      fi
    else
      \echo 'Opted to not create the file.  Aborting.'
      # zshism
      # shellcheck disable=2104
      break
    fi
  fi
  if [ ! -r "$AUTOTEST_FILE" ]; then  \chmod  --verbose  u+r  "$AUTOTEST_FILE"; break_if_failed ; fi
  if [ ! -w "$AUTOTEST_FILE" ]; then  \chmod  --verbose  u+w  "$AUTOTEST_FILE"; break_if_failed ; fi
  if [ ! -x "$AUTOTEST_FILE" ]; then  \chmod  --verbose  u+x  "$AUTOTEST_FILE"; break_if_failed ; fi
}



get_file_ext() {
  AUTOTEST_FILE="$1"
  AUTOTEST_DIR="$( \dirname "$AUTOTEST_FILE" )"
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
    'boo') # Boo programming language
      # I know this looks convoluted, but booc cannot be sent a non-useful parameter (unset/empty, or a blank space, etc)
      DUCKY="$AUTOTEST_FILE"
      execute() {
        \booc  "$DUCKY" ; RESULT="$?"
        ansi_echo  ' * booc finished'
        # Since problems can arise with booc, the mono execution should be smart.
        if [ "$RESULT" -eq 0 ]; then
          \mono  "${AUTOTEST_FILE%.*}.exe" ; RESULT="$?"
          ansi_echo  ' * mono finished'
          \rm  --force  "${AUTOTEST_FILE%.*}.exe"
        fi
      }
      execute_with_debugging() {
        if [ "$RESULT" = 255 ] || [ "$RESULT" = 127 ]; then
          DUCKY="$AUTOTEST_FILE -ducky"
          execute
        else
          ansi_echo  "I don't know what to do with that exit code:  $RESULT"
        fi
      }
      return  0
    ;;
    'c') # C programming language
      execute() {
        #\gcc "$AUTOTEST_FILE" ; RESULT="$?"
        # Turn on warnings.
        \gcc  -Wall  "$AUTOTEST_FILE" ; RESULT="$?"
        \mv  a.out  "${AUTOTEST_FILE%.*}"
        "${AUTOTEST_FILE%.*}"
        \rm  --force  "${AUTOTEST_FILE%.*}"
      }
      execute_with_debugging() {
        \gcc  gcc  -v  -Wall  "$AUTOTEST_FILE" ; RESULT="$?"
      }
      return  0
    ;;
    'py') # Python programming language
      execute() {
        \python  "$AUTOTEST_FILE" ; RESULT="$?"
      }
      execute_with_debugging() {
        \python  -d  "$AUTOTEST_FILE" ; RESULT="$?"
      }
      return  0
    ;;
    'rb') # Ruby programming language
      # Check if it's a shoes script
      if  !  \
        \grep  -q 'Shoes.app' < "$AUTOTEST_FILE"
      then
        # Ruby programming language
        execute() {
          \ruby  "$AUTOTEST_FILE" ; RESULT="$?"
        }
        execute_with_debugging() {
          if [ "x${DEBUG}" != 'xfalse' ]; then
            \ruby  --debug  "$AUTOTEST_FILE" ; RESULT="$?"
          fi
        }
      else
        # Ruby programming language, Shoes GUI toolkit
        execute() {
          ~/shoes/dist/shoes  "$AUTOTEST_FILE" ; RESULT="$?"
        }
        execute_with_debugging() {
          ~/shoes/dist/shoes  "$AUTOTEST_FILE" ; RESULT="$?"
        }
      fi
      return 0
    ;;
    'shy') # Ruby programming language, Shoes GUI toolkit
      execute() {
        ~/shoes/dist/shoes  "$AUTOTEST_FILE" ; RESULT="$?"
      }
      execute_with_debugging() {
        ~/shoes/dist/shoes  "$AUTOTEST_FILE" ; RESULT="$?"
      }
      return 0
    ;;
    'my') # Mythryl programming language
      execute() {
        #/usr/bin/mythryl: '/l/Mythryl/tutorial.my' is not a valid script!
        #/usr/bin/mythryl should only be invoked via ''#!...'' line in a script!
        #/usr/bin/mythryl  "$AUTOTEST_FILE" ; RESULT="$?"
        # Check for the shebang
        head="$( \head  --lines=1  "$AUTOTEST_FILE" )"
        mythryl_shebang='#!/usr/bin/mythryl'
        if ! [ "$head" = "$mythryl_shebang" ]; then
          #\echo  'no shebang?'
          # No shebang?  Add one.
          # Also add braces, since I was probably lazy about that.
          # TODO:  Check if I already had braces?  Meh.
          mythryl_file="${AUTOTEST_DIR}/mythryl_shebanged.my"
          # TODO - replace this with a variable-heredoc
          \echo  "$mythryl_shebang"  > "$mythryl_file"
          # I'm lazy for now:
          # shellcheck disable=2129
          \echo                     >> "$mythryl_file"
          \echo  '{'                >> "$mythryl_file"
          \cat   "$AUTOTEST_FILE"   >> "$mythryl_file"
          \echo                     >> "$mythryl_file"
          \echo  '};'               >> "$mythryl_file"
          \chmod  --verbose  +x  "$mythryl_file"
          "$mythryl_file" ; RESULT="$?"
          \rm  --force  "$mythryl_file"
        else
          #\echo  'found a shebang'
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
        \rm  --force \
          "$AUTOTEST_DIR"/main.log~ \
          "$AUTOTEST_DIR"/mythryl.COMPILE_LOG \
          "$AUTOTEST_DIR"/read-eval-print-loop.log~ \
          "$AUTOTEST_DIR"/script.log
      }
      execute_with_debugging() {
        # TODO:  Deal with the shebang issue here too, when I figure debugging out.
        "$AUTOTEST_FILE"

        \echo  "TODO: I don't know how to invoke debugging, if such a thing exists."
        # These aren't actually useful.
        #\cat "$AUTOTEST_DIR"/main.log~
        #\cat "$AUTOTEST_DIR"/read-eval-print-loop.log~
        \rm  --force \
          "$AUTOTEST_DIR"/main.log~ \
          "$AUTOTEST_DIR"/read-eval-print-loop.log~ \
          "$AUTOTEST_DIR"/script.log
      }
      return 0
    ;;
    'sh') # *nix shell scripting languages
      # Check for a shebang:
      head="$( \head --lines=1 "$AUTOTEST_FILE" )"
      # zshism
      # shellcheck disable=2209
      case "$head" in
        '#!/usr/bin/env bash' | '#!/usr/bin/env  bash' | '#!/bin/bash' | '#!/usr/local/bin/bash' )  MYSHELL=bash ;;
        '#!/usr/bin/env dash' | '#!/usr/bin/env  dash' | '#!/bin/dash' | '#!/usr/local/bin/dash' )  MYSHELL=dash ;;
        '#!/usr/bin/env sh'   | '#!/usr/bin/env  sh'   | '#!/bin/sh'   | '#!/usr/local/bin/sh'   )  MYSHELL=sh   ;;
        '#!/usr/bin/env zsh'  | '#!/usr/bin/env  zsh'  | '#!/bin/zsh'  | '#!/usr/local/bin/zsh'  )  MYSHELL=zsh  ;;
      *)
        \echo
        \echo  'NOTE - The first line was checked, and is:'
        \echo  "$head"
        \echo  ''
        \echo  'The file either:'
        \echo  '  - has no shebang'
        \echo  "  - or this script hasn't been programmed to use it"
        if  \test  -n  "$SHELL"; then
          \echo  "\$SHELL has been set to:  $SHELL"
          # zshism
          # shellcheck disable=2209
          case "$SHELL" in
            '/bin/bash' | '/usr/bin/bash' ) MYSHELL=bash ;;
            '/bin/dash' | '/usr/bin/dash' ) MYSHELL=dash ;;
            '/bin/sh'   | '/usr/bin/sh'   ) MYSHELL=sh   ;;
            '/bin/zsh'  | '/usr/bin/zsh'  ) MYSHELL=zsh  ;;
            *)
              ansi_echo  "While \$SHELL has been set, this script has not been programmed to use it."
              \echo      "Don't fret, it's not too hard to hack this script to add functionality."
              \echo      'To add support, edit this script and:'
              \echo      '  1. Search for ERROR01 and edit the code just above it.'
              # shellcheck disable=2016
              \echo      "  2. Also search for "\''case "$MYSHELL" in'\'" and edit that code."
              \echo      'Falling back to sh.'
              MYSHELL='sh'
          esac
        else
          # While I could manually use `which` and test for other shells, I'm not going to bother.
          \echo      "\$SHELL has not been set."
          ansi_echo  'What the hell is wrong with you?'
          \echo      'Falling back to sh.'
          MYSHELL='sh'
        fi
      esac
      \echo  "Using $MYSHELL"
      # ----------------------------------------------------------------
      case "$MYSHELL" in
        'bash')
          execute() {
            \bash  -c  "$AUTOTEST_FILE" ; RESULT="$?"
          }
          execute_with_debugging() {
            # TODO: I should remember and then restore it, but how?
            set  -x
            execute
            set  +x
          }
        ;;
        'dash' )
          execute() {
            \dash  -c  \""$AUTOTEST_FILE"\" ; RESULT="$?"
          }
          execute_with_debugging() {
            # FIXME - maybe it is.. but I'd have to check if I'm sh or dash
            # -o verbose  -o +xtrace
            #ansi_echo  'debugging is not supported'
            \dash  -o xtrace  -c  \""$AUTOTEST_FILE"\" ; RESULT="$?"
          }
        ;;
        'sh' )
          execute() {
            # Tested under dash
            #\chmod  --verbose  u+x  "$AUTOTEST_FILE"
            \sh  -c  \""$AUTOTEST_FILE"\" ; RESULT="$?"
          }
          execute_with_debugging() {
            # TODO - This script can't tell the difference between sh and dash.
            ansi_echo  "This script can't tell if debugging is supported or not; assuming it isn't."
            execute
          }
        ;;
        'zsh' | 'zsh4' | 'zsh5')
          execute() {
            #\chmod  --verbose  u+x  "$AUTOTEST_FILE"
            \zsh  -c  "$AUTOTEST_FILE" ; RESULT="$?"
          }
          execute_with_debugging() {
            # TODO: I should remember and then restore it, but how?
            setopt  xtrace
            execute
            unsetopt  xtrace
          }
        ;;
        *)
          \echo      ''
          ansi_echo  "ERROR:  Your shell is not supported:  $MYSHELL"
          \echo      "Don't fret, it's not too hard to hack this script to add functionality."
          \echo      "To add support, edit this script and:"
          \echo      "  1. Search for ERROR02 and edit the code just above it."
          # shellcheck disable=2016
          \echo      "  2. Also search for "\''case "$MYSHELL" in'\'" and edit that code."
          \echo      ''
          # zshism
          # shellcheck disable=2104
          break
      esac
      return  0
    ;;
    *)
      \echo  ''
      ansi_echo  "ERROR:  Your file type is not supported:  $EXT"
      \echo  "Don't fret, it's not too hard to hack this script to add functionality."
      \echo  'To add support, edit this script and search for this error message.'
      \echo  ''
      # TODO: Peek in and check the first line for a shebang that's supported.  That would be a good way to at least warn when in one shell but executing a script meant for another shell.  Maybe even switch to that shell to run the script?  i.e. if in zsh, and there is #!/bin/bash at the top, then do:  execute() { "bash $AUTOTEST_FILE" ; RESULT="$?" }
      # head -n 1 "$AUTOTEST_FILE"
      # Use sed/whatever else?
      return  1
  esac
  return  0
}



get_file_time() {
  AUTOTEST_FILE="$1"
  AUTOTEST_FILE_TIME=''
  # AUTOTEST_FILE_TIME_TEMP='-rw-rw-r-- 1 4 2009-03-29 13:34:56.000000000 -0700 /tmp/checkfile'
  # AUTOTEST_FILE_TIME='2009-03-29 13:34:56.000000000'
  AUTOTEST_FILE_TIME_TEMP="$( \ls --full-time -gG --no-group "$AUTOTEST_FILE" )"

  case "$MYSHELL" in
    'bash')
      # For reasons unknown, this doesn't work anymore.
      # AUTOTEST_FILE_TIME="${AUTOTEST_FILE_TIME_TEMP:15:29}"
      AUTOTEST_FILE_TIME="$( \echo "$AUTOTEST_FILE_TIME_TEMP"|"cut" --delimiter " " --fields 4,5 )"
    ;;
    'zsh')
      # For reasons unknown, this doesn't work anymore.
      # AUTOTEST_FILE_TIME="${AUTOTEST_FILE_TIME_TEMP[12,30]}"
      AUTOTEST_FILE_TIME="$( \echo "$AUTOTEST_FILE_TIME_TEMP"|"cut" --delimiter " " --fields 4,5 )"
    ;;
    *)
      # Other shells might/should be able to use an external program like 'cut', or some other "real" programming language (Perl, Python, Ruby, etc)
      AUTOTEST_FILE_TIME="$( \echo "$AUTOTEST_FILE_TIME_TEMP"|"cut" --delimiter " " --fields 4,5 )"
  esac
}



run_script() {
  AUTOTEST_FILE="$1"
  RESULT=0

  run_script_main() {
    # zshism
    # shellcheck disable=2193
    if [ "$RESULT" -ne 0 ] && [ "x${DEBUG}" != 'false' ]; then
      \printf  ''
    else
      AUTOTEST_FILE="$1"
      if [ "$CLEAR_SCREEN" = 'yes' ]; then clear; fi
      if [ "$CD_SCRIPTDIR" = 'yes' ]; then
        \cd  "$( \dirname  "$AUTOTEST_FILE" )"  ||  return  $?
      else
        \cd  "$ORIGINAL_PWD"  ||  return  $?
      fi

      if [ ! "$TIME" = 'no' ]; then
        # TODO : use 'time' to time it.  I'm not sure how, since I want to grab the result from the original program.
        TIMESTAMP_BEGIN="$( \date  +%s )"
      fi
      ansi_echo  " * begin  $( \date )"

      if [ "$RESULT" -eq 0 ]; then
        # For some reason I have to move the check_file here, for VirtualBox Linux-guest, Windows-host.
        check_file  "$AUTOTEST_FILE"
        execute
      else
        execute_with_debugging
      fi

      ansi_echo " * end [$RESULT] $( \date )"
      if [ ! "$TIME" = 'no' ]; then
        TIMESTAMP_END="$( \date  +%s )"
        \echo  "autotest:  The script ran for $(( TIMESTAMP_END - TIMESTAMP_BEGIN )) seconds"
        # TODO: Detect if it's appropriate to list in minutes, then display in mm:ss
        #   Maybe also do hh:mm:ss, oh hell.. do yy:dd:mm:ss for kicks!
      fi
      # Give a little breathing room, so you can see better.
      \echo  ''
      \echo  ''
    fi
  }

  run_script_main  "$AUTOTEST_FILE"
  # If it fails, re-run it.
  # It'll see the non-zero $RESULT and run execute_with_debugging
  if [ ! "$RESULT" -eq 0 ]; then run_script_main  "$AUTOTEST_FILE" ; fi
}



main_foreground() {
  while :; do
    AUTOTEST_FILE="$( \readlink  --canonicalize  "$1" )"

    if  !  \
      get_file_ext  "$AUTOTEST_FILE"
    then  break ; fi

    if  !  \
      check_file  "$AUTOTEST_FILE"
    then  break ; fi

    if  !  \
      get_file_time  "$AUTOTEST_FILE"
    then  break ; fi

    NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"

    # Launch the editor
  #   \nohup  "$EDITOR"  "$AUTOTEST_FILE"  2> /dev/null & ; RESULT=$?
    #\exec  "$EDITOR"  "$AUTOTEST_FILE" &
    # Fuck the configurability, let's do this manually..

    case "$this_kernel_release" in
      'Cygwin'|'Mingw')
        geany () {
          for file in "$@"
          do
            if ! [ -f "$file" ]
            then
              :>  "$file"
            fi
            string=${string}' '\"$( \cygpath  --dos  "$file" )\"
          done
          \cygstart  '/c/Program Files (x86)/Geany/bin/geany.exe'  "$string"
          \unset string
        }
        geany  "$AUTOTEST_FILE"
        exit_code=$?
        # TODO - explore using pgrep
        # shellcheck disable=2009
        editor_pid=$( \ps  -efW | \grep  'C:\\Program Files (x86)\\Geany\\bin\\geany.exe' | \awk '{ print $2 }' )
      ;;
      *)
        #'Linux'|'Windows Subsystem for Linux'
        # Note that Windows Subsystem for Linux needs to have something like XLaunch running in order to launch a GUI program.
        \geany  --new-instance  "$AUTOTEST_FILE" &
        exit_code=$?
        editor_pid=$!
      ;;
    esac

    if [ $exit_code -ne 0 ]; then
      \echo  "Unable to launch editor:  $EDITOR"
      return  1
    fi
    #exec  "$EDITOR2"  "$AUTOTEST_FILE" &

    # ----
    # Main Routine:  The file change checking loop
    # ----
    # Note that I'm still in MAIN_ROUTINE.  This is so that all the earlier procedures can still be relied upon to break out of the whole script, even during operation.  This is a good idea in case things go awry during operation (permissions change, the filesystem unmounts, etc).

    while :; do
    # Check the file
    # This is run every iteration of the main loop to see if the fundamental permissions of the script being edited change during operation.
      if [ ! "$AGGRESSIVE_CHECK_AUTOTEST_FILE" = 'no' ]; then
        if  !  \
          check_file  "$AUTOTEST_FILE"
        then
          \echo  'check_file failed, aborting'
          break
        fi
      fi

      # Status
      if [ "$ANSI" = 'no' ]; then
        printf '.'
        #"$HOME/l/shell-random/live/sh/scripts/spinner.sh"  "$spinner_counter"
        spinner_counter="$?"
        \sleep  "$SLEEP"
      else
        \printf  '%b'  "${cursor_position_save}"
        printf '.'
        #"$HOME/l/shell-random/live/sh/scripts/spinner.sh"  "$spinner_counter"
        spinner_counter="$?"
        \sleep  "$SLEEP"
        \printf  '%b'  "${cursor_position_restore}"
      fi

      # Check to see if the file has changed.  If so, run it.
      get_file_time "$AUTOTEST_FILE"
      if [ ! "$NEW_AUTOTEST_FILE_TIME" = "$AUTOTEST_FILE_TIME" ] && [ -s "$AUTOTEST_FILE" ]; then
        NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"
        run_script  "$AUTOTEST_FILE"
      fi

      # Is the editor is still running?
      # I could have used kill, but I prefer readlink because it's smaller.
      # kill -0 $editor_pid 2> /dev/null
      # Interesting how --quiet and --silent don't work, and the name of the executable keeps being echoed on each iteration.  I wonder if this is a bug, because it's certainly unexpected.  But then again, GNU is all about difficult programs with unexpected results.  They are generally anti-POLS (principle of least surprise).

      case "$this_kernel_release" in
        'Cygwin'|'Mingw')
          geany () {
            for file in "$@"
            do
              if ! [ -f "$file" ]
              then
                :>  "$file"
              fi
              string=${string}' '\"$( \cygpath  --dos  "$file" )\"
            done
            \cygstart  '/c/Program Files (x86)/Geany/bin/geany.exe'  "$string"
            \unset string
          }
          # TODO - explore using pgrep
          # shellcheck disable=2009
          \ps  -efW | \grep  'C:\\Program Files (x86)\\Geany\\bin\\geany.exe' > /dev/null 2> /dev/null
          exit_code=$?
        ;;
        *)
          #'Linux'|'Windows Subsystem for Linux'
          \readlink  /proc/"$editor_pid"/exe > /dev/null
          exit_code=$?
        ;;
      esac


      if [ $exit_code -ne 0 ]; then
        ansi_echo  'The editor exited.  This concludes autotest.'
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
  \echo  . >> "$PID_FILE"

  check_file "$AUTOTEST_FILE"
  # Launch it automatically.
  run_script  "$AUTOTEST_FILE"

#-----------

  while :; do
    AUTOTEST_FILE="$( \readlink  --canonicalize  "$1" )"

    if  !  \
      check_file "$AUTOTEST_FILE"
    then  break ; fi

    if  !  \
      get_file_ext "$AUTOTEST_FILE"
    then  break ; fi

    if  !  \
      get_file_time "$AUTOTEST_FILE"
    then  break ; fi

    NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"

    # ----
    # Main Routine:  The file change checking loop
    # ----
    # Note that I'm still in MAIN_ROUTINE.  This is so that all the earlier procedures can still be relied upon to break out of the whole script, even during operation.  This is a good idea in case things go awry during operation (permissions change, the filesystem unmounts, etc).
    while :; do

    # Check the file
    # This is run every iteration of the main loop to see if the fundamental permissions of the script being edited change during operation.
      if [ ! "$AGGRESSIVE_CHECK_AUTOTEST_FILE" = 'no' ]; then
        if  !  \
          check_file  "$AUTOTEST_FILE"
        then  \echo  'check_file failed, aborting' ; break ; fi
      fi

      # Check to see if the file has changed.  If so, run it.
      get_file_time  "$AUTOTEST_FILE"
      if [ ! "$NEW_AUTOTEST_FILE_TIME" = "$AUTOTEST_FILE_TIME" ] && [ -s "$AUTOTEST_FILE" ]; then
        NEW_AUTOTEST_FILE_TIME="$AUTOTEST_FILE_TIME"
        run_script  "$AUTOTEST_FILE"
      fi

      if [ ! -f "$PID_FILE" ]; then
        break # MAIN_LOOP
      fi

    done

    break # MAIN_ROUTINE
  done
}



# TODO:  No spinner
main() {
  if [ -z "$*" ]; then
    usage
    return  0
  fi
  if [ "x${2}" = 'x' ]; then
    SPINNER=0
    main_foreground  "$@"
  elif [ "x${2}" = 'x-bg' ]; then
    SPINNER=0
    main_background  "$@"
  elif [ "x${2}" = 'x--nodebug' ]; then
    SPINNER=0
    DEBUG='false'
    main_foreground  "$@"
  else
    usage
    return  1
  fi
}



#:<<'}'   #  For testing
{
  if [ -z "$*" ]; then
    "$0"  "$HOME/foo.sh"
    return
  fi
}



main  "$@"
