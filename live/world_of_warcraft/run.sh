#!/bin/bash

# TODO - an easy way to swap Config.wtf files around, for raiding.


# --
# -- TROUBLESHOOTING
# --

# May be a fix for occasional issues
#  \wine  ./Agent.exe --nohttpauth


# --
# -- CONFIGURATION
# --

# running with  -opengl  will disable most of the advanced eye-candy, but will greatly improve performance.
# I have some old -opengl notes, but I can no longer reproduce any issues (on 64bit):
  # -opengl solves black/blank screen issues (was happening at odd angles) on 32bit (on 64bit was fine).  Might also be a driver issue, but whatever..
  # however, the consequence is when using a viewport the game world it will have odd colours in the blanked-out area(s?).  Oh well.  Don't resize+zoom out a bit.
  # Also, it's fucking horribly slow in LFR..
  # Seems to only be fixable with a lowered view distance..
  # need to update the driver?
  # this doesn't seem to work:   wine wow.exe -d3d
  # [nothing helpful]  https://help.ubuntu.com/community/WorldofWarcraft/Troubleshooting
  # Turned out to be an issue with Config.wtf, textures perhaps..
opengl=-opengl
# The alternate display you'd like to run things on.
# FIXME - Occasional issues with the screen going black when using an alternate x display.  Cannot properly reproduce.
# FIXME - having audio issues when using an alternate x display and switching back to :0  Cannot properly reproduce.
_display=:3



_wow_die(){
  \echo ""
  \echo " * ^c detected, killing WoW."
  _wow_teardown
}
trap _wow_die INT



_wow_setup(){
  \echo  " * Setup.."
  \gksudo  -u root  "\echo"
  if [[ x$_display == x ]]; then
    ~/.config/openbox/wine.sh
    \echo  " - disabling the screen saver"
    \xscreensaver-command  -exit
  fi
  \echo  " - Deleting creature cache (for SilverDragon)"
  \rm  --force  --verbose  /l/wow/_game/Cache/WDB/enUS/creaturecache.wdb
  # This is necessary if not using -opengl and using high settings.
  /l/bin/processor_heat.sh  --yes ; heatup=$?
}



_wow_run(){
  if [[ ! x$1 == "xnomumble" ]]; then
    if [[ x$_display == x ]]; then
                 /l/bin/mumble.sh  $@ &
    else
      DISPLAY=$_display  /l/bin/mumble.sh  $@ &
    fi
  fi
  \echo " * Launching WoW"
#  \sudo  \swapoff  --all

  if [[ x$1 == "xupdate" ]]; then
    __GL_THREADED_OPTIMIZATIONS=1  WINEDEBUG=-all  WINEPREFIX=/l/wow/_wineprefix/  /usr/bin/wine \
      "/l/wow/_game/World of Warcraft Launcher.exe"
    \echo  "Press enter when the update has concluded.."
    \read  __
  else
    # Launch on a new X session on display 3
    # Control-Alt-F7/F8 will swap between the two displays.

    if [[ x$_display != x ]]; then
      \sudo  \X  $_display  -ac  -terminate &
      \sleep 2
      #  `ck-launch-session`  resolves audio issues.
      # I seem to be forced to use xterm.
      # I don't know how to have xterm close.
      DISPLAY=$_display  \xterm  -e  /usr/bin/ck-launch-session &
      # Optional, but useful.
      # I don't understand why it ignores ~/.config/openbox/* and there are no options to start with alternate configuration, to force its use.
      DISPLAY=$_display  /usr/bin/openbox  --startup &
    fi

:<<NOTES
  # NVidia threaded optimizations:
  #   Renderer thread is offloaded to a seperate core
  __GL_THREADED_OPTIMIZATIONS=1
  # Major speed improvement to disable debugging:
  WINEDEBUG=-all
  WINEPREFIX=/l/wow/_wineprefix/
  # A regular user cannot nice this.  TODO - how do I nice it, but have the process run as a regular user?
  /usr/bin/wine  /l/wow/_game/Wow.exe  >> /dev/null 2>&1 &
NOTES

    # TODO - niceness.  However, wine isn't so simple to nice.. this has to be researched carefully.
    __GL_THREADED_OPTIMIZATIONS=1  WINEDEBUG=-all  WINEPREFIX=/l/wow/_wineprefix/  DISPLAY=$_display \
    /usr/bin/wine \
    /l/wow/_game/Wow-64.exe  $opengl  >> /dev/null 2>&1 &
    wowpid=$!
  fi


  # TODO - Additional niceness.  However, wine isn't so simple to nice.. this has to be researched carefully.
  \sudo  \renice  -n -10  $( \pidof wineserver )  &>  /dev/null
  \echo " ┌──────────────────────────┐ "
  \echo " │ Do not close this window │ "
  \echo " └──────────────────────────┘ "
}



_wow_teardown(){
  \echo  " * Teardown.."
  \gksudo  -u root  "\echo"
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
    Wow.exe \
    &> /dev/null
  if [[ $heatup -eq 1 ]]; then
    /l/bin/processor_cool.sh
  fi
}



# --
# -- Actual stuff
# --

_wow_setup
_wow_run  $@
\wait  $wowpid &> /dev/null
_wow_teardown
\echo  ""
\echo  " * Done."
