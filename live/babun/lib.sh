#!/usr/bin/env  zsh
# Loaded after everything else.



#debug=true

# Do not use the system's fcntl call.  Instead, use ad-hoc file locking to avoid known problems with locking on some (*cough* Windows) operating systems.
\unsetopt  hist_fcntl_lock



{  #  PATH
  # Iterating with realpath will slow down startup.
  # Workaround:  Cache the results.
  path_cache="$HOME/Babun-path-cache.txt"
  #\rm  --force  "$path_cache"
  if  [ -f "$path_cache" ]; then
    if [ $debug ]; then
      \echo  "Reading \$PATH from $path_cache"
    fi
    PATH="$( \cat $path_cache )"
  else
    if [ $debug ]; then
      \echo  "Rebuilding \$PATH for $path_cache"
    fi
    PATH="$zshdir/../babun/scripts":"$PATH"

    # Babun cannot deal with relative paths.  Iterate through and correct them:
    # FIXME - An unavoidable slowdown in startup.  Maybe these results could be cached in a file..
    \unset  __
    oldIFS="$IFS"
    IFS=':'
    for i in $PATH
    do
      if [ $debug ]; then
        \echo  "Processing PATH: $i"
      fi
      __="$__":$( \realpath "$i" 2> /dev/null )
    done
    IFS="$oldIFS"
    PATH="$__"
    \echo  "$PATH" > "$path_cache"
    \unset  __
    \unset  path_cache
  fi
}



{  #  Variables
  # Note that I use --mixed to use forward-slashes (/) and not backslashes (\) because backslashes are an impossible problem to overcome.
  # Windows can work with forward slashes just fine, so don't worry.

  # CSIDL_PROGRAM_FILES 0x0026  --  This still reports (x86)
  PF="$( \cygpath  --folder 0x0026 )"
  # FIXME - Semi-manually doing it:
  PF="$( \dirname  "$PF" )/Program Files"
  # CSIDL_PROGRAM_FILESX86 0x002a
  PFx="$( \cygpath  --folder 0x002a )"
  # The Windows-style versions:
  wPF="$(  \cygpath  --mixed  "$PF"  )"
  wPFx="$( \cygpath  --mixed  "$PFx" )"
  # CSIDL_PROFILE 0x0028
  windows_home_as_linux="$( \cygpath  --folder 0x0028 )"
  windows_home_as_windows="$( \cygpath  --mixed  "$windows_home_as_linux" )"

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
  for file in "$@"; do
    if ! [ -f "$file" ]; then
      # Workaround:  \cygpath  can't handle nonexistent files:
      \touch  "$file"
    fi
    string=${string}' '\"$( \cygpath  --dos  "$file" )\"
  done
#  \cygstart  "$PFx/Geany/bin/geany.exe"  "$string" &
  \cygstart  "/d/Program Files (x86)/Geany/bin/geany.exe"  "$string" &
  \unset  string
}



\unset  debug
