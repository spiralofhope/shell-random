#!/usr/bin/zsh

:<<HEREDOC

I could just do this:
  firefox -no-remote -P
.. and then it'll use the firefox profile picker.
However, this script lets me do more stuff, if I ever feel like it.

HEREDOC

# TODO:  Don't display the column header at all.
# TODO:  Place the cursor on / highlight the first menu entry:  'default'

result=$(
  \zenity \
    --list \
    --column="" \
    --title="Firefox" \
    --text="Select a profile" \
    "default" \
    "wow" \
    "p" \
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
    /l/Linux/bin/Firefox/firefox -no-remote -P $result &
    # I used to be able to do the following to open content in a new tab:
    #/l/Linux/bin/Firefox/firefox -a firefox -remote "openurl(%s,new-window)" 
    # I have no way of opening a new instance of firefox.
  else
    # process not found
    /l/Linux/bin/Firefox/firefox -P $result &
    # Can be used with:
    #/l/Linux/bin/Firefox/firefox -P default -a firefox -new-tab "%s"
  fi

fi
\echo $result
