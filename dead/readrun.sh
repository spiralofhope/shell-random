#!/bin/bash
# medit exits ever time, nomatter what I sleep for.

# I could read character-by-character and also catch escape!
unset READ
until [ ! "$READ" == "" ]; do
  read READ
done
nohup $READ >> /dev/null&
# Sleeping so that when this script ends it doesn't kill what was launched.
# disown
sleep 1
# TODO: Minimize or iconify this window so that it's out of the way in the meantime?
