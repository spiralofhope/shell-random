#!/usr/bin/env  zsh
# Loaded after everything else.



PF=$( \realpath '/c/Program Files' )
PFx="${PF} (x86)"
# The Windows-style versions:
wPF=$(  \cygpath  "$PF"  )
wPFx=$( \cygpath  "$PFx" )



geany() {
  # The basic solution won't work with symbolic links:
  #\cygstart  '/c/Program Files (x86)/Geany/bin/geany.exe'  $*  &
  for file in $*; do
    if  [ -L "$file" ]; then
      string=${string}' '\"$( \cygpath  --dos  "$file" )\"
    else
      string=${string}' '\"$file\"
    fi
  done
  \cygstart  "$PFx/Geany/bin/geany.exe"  "$string" &
}













:<<'NOTES'
# It's probably just a lock on this file preventing ~/.zshrc source-ing it.
problem(){  # Fix startup freezing

# Problem:
# Windows file locking will hit $HISTFILE, causing a new shell to freeze on startup.

# Reproduction:
# Start one instance of Babun
# nano (this file), make no changes
# Start another instance of Babun
# Instance 2 freezes and never gets to the prompt.
# Exit nano from instance 1
# type rm (with nothing else)
# The prompt on instance 2 un-freezes

unsetopt inc_append_history
unsetopt share_history
# This frees up locks on $HISTFILE
\rm >> /dev/null &

# No luck with this
\flock  --unlock  "$0"
}
NOTES
