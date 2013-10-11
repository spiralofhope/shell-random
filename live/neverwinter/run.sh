#!/bin/bash



# --
# -- TROUBLESHOOTING
# --

# Be patient when running, the second load screen is fucking slow, especially after an initial install.



# --
# -- CONFIGURATION
# --

# The alternate display you'd like to run things on.
# FIXME - (WoW) Occasional issues with the screen going black when using an alternate x display.  Cannot properly reproduce.
# FIXME - (WoW) having audio issues when using an alternate x display and switching back to :0  Cannot properly reproduce.
# FIXME - (WoW) Major keyboard sticking issues when using an alternate x display.  This was an old problem previously solved on :0 .. but how did I solve it?
_display=:3



_neverwinter_die(){
  \echo ""
  \echo " * ^c detected, killing Neverwinter."
  _neverwinter_teardown
}
trap _neverwinter_die INT



_neverwinter_setup(){
  \echo  " * Setup.."
  \gksudo  --message "Setting up Neverwinter.."  --user root  "\echo -n"
  if [[ x$_display == x ]]; then
    ~/.config/openbox/wine.sh
    \echo  " - disabling the screen saver"
    \xscreensaver-command  -exit
  fi
  # May only be necessary if using high settings.
  /l/bin/processor_heat.sh  --yes ; heatup=$?
}



_neverwinter_run(){
  # Not currently using mumble..
  #if [[ ! x$1 == "xnomumble" ]]; then
    #if [[ x$_display == x ]]; then
                 #/l/bin/mumble.sh  $@ &
    #else
      #DISPLAY=$_display  /l/bin/mumble.sh  $@ &
    #fi
  #fi

  # FIXME - can I connect directly?  Can I join a specific channel?
  # DISPLAY=$_display  /l/TeamSpeak/update &
  DISPLAY=$_display  /l/TeamSpeak/ts3client_runscript.sh &

  \echo " * Launching Neverwinter"
  #\sudo  \swapoff  --all

  # Launch on a new X session on display 3
  # Control-Alt-F7/F8 will swap between the two displays.
  if [[ x$_display != x ]]; then
    \sudo  \X  $_display  -ac  -terminate &
    x_windows_pid=$!
    \sleep 2
    #  `ck-launch-session`  resolves audio issues.
    # I seem to be forced to use xterm.
    # I don't know how to have xterm close.
    DISPLAY=$_display  \xterm  -e  /usr/bin/ck-launch-session &
    # Optional, but useful.
    # I don't understand why it ignores ~/.config/openbox/* and there are no options to start with alternate configuration, to force its use.
    DISPLAY=$_display  /usr/bin/openbox  --startup &
  fi

  # Worked with wine 1.6
  # WINEPREFIX=$PWD/_wineprefix  \wine  Arc.exe

  # Worked with wine 1.7
  # WINEPREFIX=$PWD/_wineprefix  \wine  "C:\Program Files (x86)\Perfect World Entertainment\Arc\Arc.exe"  -enablerawinputsupport 0

:<<NOTES
  NVidia threaded optimizations.  Renderer thread is offloaded to a seperate core:
    __GL_THREADED_OPTIMIZATIONS=1
  Major speed improvement to disable debugging:
    WINEDEBUG=-all
  Reportedly fixes a jerky mouse:
    -enablerawinputsupport 0
  TODO - How do I have a nice it, but have the process run as a regular user?
  TODO - how can I have the command line run with \ to break things onto separate lines to make it nice and clean?

  I installed via Arc, because that's forced now -- although the previous installer is said to work.
  This is how it would normally be run:
  "C:\Program Files (x86)\Perfect World Entertainment\Arc\Arc.exe"
  However, since Arc is actually optional, it can go fuck itself.
NOTES
  #__GL_THREADED_OPTIMIZATIONS=1  WINEDEBUG=-all  WINEPREFIX=$PWD/_wineprefix \

  # Testing:
  __GL_THREADED_OPTIMIZATIONS=1  WINEDEBUG=-all  WINEPREFIX=$PWD/_wineprefix  DISPLAY=$_display \
    /usr/bin/wine \
    "C:\Program Files (x86)\Perfect World Entertainment\Neverwinter_en\Neverwinter.exe" \
      -enablerawinputsupport 0 \
    >> /dev/null 2>&1

  neverwinterpid=$!

  # TODO - Additional niceness.
  \sudo  \renice  -n -10  $( \pidof wineserver )  &>  /dev/null
  \echo " ┌──────────────────────────┐ "
  \echo " │ Do not close this window │ "
  \echo " └──────────────────────────┘ "
}



_neverwinter_teardown(){
  \echo  " * Teardown.."
  # gksudo segfaults if the screen saver kicks in and gksudo fails to grab the keyboard/mouse.
  #   Yes, I want to actually grab the keyboard and mouse and keep a gui interface here, instead of having the user hunt for the following commandline 'sudo'.
  false
  until [[ $? -eq 0 ]]; do
    \gksudo  --message "Tearing down Neverwinter.."  --user root  "\echo -n"
  done
  if [[ x$_display == x ]]; then
    ~/.config/openbox/unwine.sh
    \echo " - enabling the screen saver"
    \xscreensaver  -nosplash &
  fi
  \echo " - Killing any lingering processes."
  /usr/bin/wineboot --shutdown
  /usr/bin/wineserver --kill
  \killall \
    xkill \
    explorer.exe \
    plugplay.exe \
    services.exe \
    winedevice.exe \
    wineserver \
    Agent.exe \
    ` # Neverwinter-specific ` \
    ` # TODO? - What would I have to kill to stop Neverwinter? ` \
    Arc.exe \
    ` # TODO? - TeamSpeak? ` \
    &> /dev/null
  if [[ $heatup -eq 1 ]]; then
    /l/bin/processor_cool.sh
  fi
  # I don't know what applications may still be lingering.  Hopefully this will kill everything.
  \sudo  \kill  $x_windows_pid
}



# --
# -- Actual stuff
# --

_neverwinter_setup
_neverwinter_run  $@
\wait  $neverwinterpid &> /dev/null
_neverwinter_teardown
\echo  ""
\echo  " * Done."
