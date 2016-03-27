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
    /usr/bin/xterm
    /usr/bin/rxvt
    /usr/bin/xfce4-terminal
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

    /usr/bin/xterm)
      \setsid  $i \
        ` # Output to the window should not have it scroll to the bottom.` \
      -si \
        ` # No visual bell. ` \
      +vb \
        ` # No scrollbar. ` \
      +sb \
        ` # Jump scrolling.  Normally, text is scrolled one line at a time; this option allows xterm to move multiple lines at a time so that it does not fall as far behind. Its use is strongly recommended since it makes xterm much faster when scanning through large amounts of text. ` \
      -j \
        ` # Indicates that xterm may scroll asynchronously, meaning that the screen does not have to be kept completely up to date while scrolling. This allows xterm to run faster when network latencies are very high and is typically useful when running across a very large internet or many gateways. ` \
      -s \
        ` # xterm should assume that the normal and bold fonts have VT100 line-drawing characters.  It sets the forceBoxChars resource to "true". ` \
      +fbx \
      -bg black \
      -fg gray \
      -cr darkgreen \
      -sl 10000 \
      -geometry 80x24+0+0 \
      "$@" &
    ;;

    /usr/bin/rxvt)
      \setsid  $i \
        ` # Output to the window should not have it scroll to the bottom.` \
      -si \
        ` # No visual bell. ` \
      +vb \
        ` # No scrollbar. ` \
      +sb \
        ` # Jump scrolling.  Normally, text is scrolled one line at a time; this option allows xterm to move multiple lines at a time so that it does not fall as far behind. Its use is strongly recommended since it makes xterm much faster when scanning through large amounts of text. ` \
      -j \
      -bg black \
      -fg gray \
      -cr darkgreen \
      -sl 10000 \
      -geometry 80x24+0+0 \
      "$@" &
    ;;

    /usr/bin/xfce4-terminal)
      \setsid  $i \
        "$@" &
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
