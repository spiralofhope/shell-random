#!/usr/bin/env  zsh
# Loaded after everything else.



#debug=true



{  #  Variables
  # TODO - I don't know how to detect where "Program Files" is.
  PF=$( \realpath '/c/Program Files' )
  # TODO - I don't know how to detect where "Program Files (x86)" is.
  PFx="${PF} (x86)"
  # The Windows-style versions:
  wPF=$(  \cygpath  --mixed  "$PF"  )
  wPFx=$( \cygpath  --mixed  "$PFx" )
  windows_home_as_linux="$( \cygpath  --desktop )"
  # TODO - I don't know how to detect where the user's folder is.
  windows_home_as_linux="$( \dirname  "$windows_home_as_linux" )"
  # Note that I use --mixed to use forward-slashes (/) and not backslashes (\) because backslashes are an impossible problem.
  # Windows can work with forward slashes just fine, so don't worry.
  windows_home_as_windows="$( \cygpath --desktop  --mixed )"
  # TODO - I don't know how to detect where the user's folder is.
  windows_home_as_windows="$( \dirname  "$windows_home_as_windows" )"

  if [ $debug ]; then
    \echo  "PF   = $PF"
    \echo  "PFx  = $PFx"
    \echo  "wPF  = $wPF"
    \echo  "wPFx = $wPFx"
    \echo  "windows_home_as_linux   = $windows_home_as_linux"
    \echo  "windows_home_as_windows = $windows_home_as_windows"
  fi
}



geany() {  #  The GUI editor
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
  \unset  string
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
