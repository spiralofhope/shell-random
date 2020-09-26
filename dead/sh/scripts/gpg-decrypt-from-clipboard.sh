#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
#   (I like using backslashes)

# A helper to decrypt a PGP block copied into the clipboard.

# TODO - Also have the decrypted text in the clipboard.
# TODO - Pipe gpg back into the clipboard.
# TODO - Summon kwrite via the clipboard.
# FIXME? - I don't know if the  ;\  should just be a  \  or not, another version of this file was just  \


# shellcheck  disable=1117
\nohup  \
\xterm  \
  -fn 9x15  \
  -bg black  \
  -fg gray  \
  -sl 10000  \
  -geometry 113x46+0+0  \
  -title 'decrypting'  \
  -e  \
  "$SHELL" -c "
    # from the clipboard, into gpg for decryption, into kwrite.
    # TODO: use a proper editor which can be set to read-only!
    \xclip  -o  -sel  clip  |\
      \gpg  -d  |\
        \kwrite  --stdin ;\
  " >> /dev/null&



:<<'}'  #  Using wmctrl  (unfinished)
{
\nohup  \
\xterm  \
  -fn 9x15  \
  -bg black  \
  -fg gray  \
  -sl 10000  \
  -geometry 113x46+0+0  \
  -title 'decrypting'  \
  -e  \
  $SHELL -c "
    # from the clipboard, into gpg for decryption and back into the clipboard
    xclip -o -sel clip  |  gpg -d  |  xclip ;\
    # check for success, and minimize if successful
    # bug: but there is no minimize, and making it below doesn't switch focus to the previous window!
    # wmctrl -F -r "decrypting" -b add,below
    # activating another program like this will completely screw over this entire script.
    # wmctrl -a "Mozilla Firefox"
    # from one clipboard to another, so I can paste it back out properly.
    # BUG: This clipboard copy vanishes once this window closes!
    xclip -o | xclip -selection clip ;\
    echo 'exiting in 5' ;\
    sleep 5 ;\
    " >> /dev/null&
}
