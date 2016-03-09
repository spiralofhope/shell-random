#!/usr/bin/zsh

:<<HEREDOC

I could just do this:
  firefox -no-remote -P
.. and then it'll use the firefox profile picker.
However, this script lets me do more stuff, if I ever feel like it.

HEREDOC

if [ -z $@ ]; then

  # TODO:  Don't display the column header at all.
  # TODO:  Place the cursor on / highlight the first menu entry:  'default'
  result=$(
    \zenity \
      --list \
      --column="" \
      --title="Firefox" \
      --text="Select a profile" \
      "0-default" \
      "1-default" \
      "1-p" \
    ` # `
  )


  # This way also works, but I don't have Xdialog installed.
  # TODO:  Check for Xdialog versus zenity, and use whatever one is installed.
  #result=$(
    #\Xdialog --stdout \
      #--radiolist "Choose your profile" 13 32 0 \
      #"default" "" "" \
      #"p" "" "" \
      #"wow" "" ""
  #)

  if [[ $? -eq 0 ]]; then
    # Sigh, why can't firefox implement a simple -new-instance
    if [ "$(pidof firefox)" ] 
    then
      # process was found
      # This had worked for years, but the functionality was broken.
      \nice -n 6 \
        /l/Firefox/bin/firefox -no-remote -P $result &
      # I used to be able to do the following to open content in a new tab:
      #/l/Firefox/bin/firefox -a firefox -remote "openurl(%s,new-window)" 
      # I have no way of opening a new instance of firefox.
    else
      # process not found

  # TODO:  Start the default profile in the no-process-found manner.
  # Then if $result was non-default, open that profile with -no-remote

      \nice -n 6 \
        /l/Firefox/bin/firefox -P $result &
      # Can be used with:
      #/l/Firefox/bin/firefox -P default -a firefox -new-tab "%s"
    fi

  fi
  \echo $result

else
  if   [[ "x$1" == "xdefault" ]]; then
    /l/bin/Firefox/default
  elif [[ "x$1" == "xp"       ]]; then
    /l/bin/Firefox/p
  else
    \echo "Not a valid profile name.  Probably."
  fi
fi
