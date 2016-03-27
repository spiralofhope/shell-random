#!/usr/bin/env  zsh
# zsh.  Because fuck all of bash's heredoc and array bullshit.


# Given a list of files
# Find the first one which exists
# Run some associated scripting



# Sometimes the user knows what they're doing, and there's really no need for this script at all.
if [[ "x$1" == 'xFORCE' ]]; then
  # Nuke $1
  shift
  \echo  "Force-running \"$@\""
  \setsid  "$@" &
  \exit  0
fi



setup() {
  # A list of programs.
  # Place them in the order you would prefer them, with the most preferred at the top.
  # These should be full paths to a file, to be safe.
  programs_list=(
    /usr/bin/xlock
    /usr/bin/xscreensaver-command
  )
}



determine_which_program_to_run() {
  for i in $programs_list; do
    if [ -f $i ]; then
      program_to_run="$i"
      break
    fi
  done
}



launch_program() {
  if [[ -z $1 ]]; then
    \echo  'ERROR:  No valid program was found.  Edit this script to add one.'
    exit  1
  else
    \echo  "Running $1"
  fi

  # The below two lines let me use $i to refer to $1 and "$@" to refer to $2 $3 $4 etc.
  #   TODO - is there a $2* or some such?
  i="$1"
  shift
  case "$i" in

    /usr/bin/xlock)
      \setsid  $i \
          ` # A black screen. ` \
        -mode blank \
          ` # Power off the monitor in 10 seconds. ` \
        -dpmsoff 10 \
          ` # When the screen saver is engaged, and the user presses a key to wake the screen up and type a password.  If they haven''t typed anything in this time, the screen saver will re-engage. ` \
        -timeout 5 \
        &
    ;;

    /usr/bin/xscreensaver-command)
      \setsid  $i \
        -lock &
    ;;

    *)
      # In theory I could
      #   - Iterate through $program_to_run
      #   - Remove all items up to and including this entry
      #   - Re-run determine_which_program_to_run
      # .. but that's too much work for too little reward.
      \echo  "ERROR:  Although $i was listed in setup() in \$programs_list, it was not programmed-for in launch_program()"
      exit  1
    ;;
  esac
}


setup
determine_which_program_to_run
launch_program  "$program_to_run"




#--v
# I used to use slock.
# I still might after I sort some other things out.
#in rx.xml I had:

  #<keybind key="W-l">                                                   <action name="Execute"> <command>
    #\sh  -c "\
      #` # Thanks to jokobm for the hint ` \
      #` # https://bbs.archlinux.org/viewtopic.php?pid=903057#p903057 ` \
      #` # ` \
      #` # Turn off the screen ` \
      #` # Set it to happen after 5s -- 0 is not valid. ` \
      #` # 0 would be bad, because it would constantly be trying to turn off the screen while inputting the password for slock, which is weird.  2 works but is still too short for my liking.` \
      #\xset  dpms 0 0 5 \
      #( \
        #` # Immediately password-protect the screen. ` \
        #\slock  &amp;&amp; \
        #` # After slock terminates, ` \
        #` # Restore the dpms timeout setting to 5m. ` \
        #/l/shell-random/git/live/slock-capital-punishment.sh  on \
      #) &amp; \
    #"
                                                                        #</command> </action> </keybind>
#--^

