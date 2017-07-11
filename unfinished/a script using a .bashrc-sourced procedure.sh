runme="/home/user/bin/bashrc_includes/temp.txt"
autotest "$runme"




:<<FAILFAILFAILFAIL
* I have no clue why I can't learn the difference between starting this at a terminal or from a launcher.  All cases think I'm not interactive.



case "$-" in
*i*)  echo This shell is interactive ;;
*)  echo This shell is not interactive>~/INT ;;
esac



:<<sdfkljnfnsjkn

# make it an absolute path
runme="/home/user/bin/bashrc_includes/temp.txt"

# I have no clue why this isn't already available.
# I guess things are different when in a script vs being at the commandline.
# I don't get it.
source "/home/user/bin/bashrc_includes/autotest.txt"

if [ -z "$PS1" ]; then
  # I'm interactive.  Go ahead.
  autotest "$runme"
else
  # I'm not interactive.  Fiddle about.
  nohup \
  xterm -fn 9x15 -bg black -fg gray -sl 10000 -geometry 80x24+0+0 -exec "$SHELL" -c "
  # comments are allowed, with no ending semicolon or backslash
  exec autotest "$runme" ;\
  echo another ;\
  sleep 5;\
  " >> /dev/null &
fi

:<<wdfokjsdflkjsdflksdfjlksdfj

# xterm -e '/bin/bash --init-file /tmp/pre'
