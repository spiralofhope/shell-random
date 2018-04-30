#!/bin/bash
# Dammit, this is bash-centric and won't work with zsh..

# 2012-05-21 on Ubuntu 12.04


# https://launchpad.net/~cheako/+archive/packages4diabloiii

# (make sure you do not have the later version repo of Ubuntu wine PPA in your apt sources)
# sudo apt-add-repository ppa:cheako/packages4diabloiii 
# sudo apt-get update
# sudo apt-get install wine
# echo 0|sudo tee /proc/sys/kernel/yama/ptrace_scope

_diablo_die(){
  \echo " * ^c detected, killing Diablo."
  _diablo_teardown
}
trap _diablo_die INT

_diablo_setup(){
  \echo " * Setup.."
  \echo " - openbox: Configuring hotkeys"
  ~/.config/openbox/wine.sh
#  \echo " - cpufreq: Heating up the processor"
#  \sudo \cpufreq-set --governor performance
}

_diablo_mumble(){
  \echo " * Mumble"
  \killall -0 mumble ; PID=$?
  if [ $PID == 0 ]; then
    \echo " - (already running)"
  else
    if [ -z $1 ]; then
      # TODO:  How do I get Mumble to minimize on startup?
      \echo " - Launching Mumble, autoconnecting.."
      \nice -n -19 \mumble "mumble://USER@SERVER:PORT/?version=1.2.0" >> /dev/null 2>&1 &
    else
      \echo " - Launching Mumble, not connecting.."
      \nice -n -19 \mumble >> /dev/null 2>&1 &
    fi
  fi
}

_diablo_run(){
  _diablo_mumble $@
  \echo " * Launching Diablo"
# I've been told to do this:
# echo 0|sudo tee /proc/sys/kernel/yama/ptrace_scope
  # Force it to think I have a one processor system, and go on processor four.  Doesn't seem to work the way I'd expect.  Fuck it.
  #\nice -n -10 \taskset --all-tasks --cpu-list 3 /usr/local/bin/wine "/1/diablo3/_game/Diablo III/Diablo III.exe" -launch  >> /dev/null 2>&1 & diablopid=$!
# Installation issues solved by running a git+patchset version.
# Connection issues solved by using this wine?  From some beta PPA or other.  Not diablo/wow-related.
  \nice -n -10 /usr/bin/wine "/1/diablo3/_game/Diablo III/Diablo III.exe" -launch  >> /dev/null 2>&1 & diablopid=$!
#  \renice -n -10 `\pidof wineserver` &> /dev/null
  \echo " ┌──────────────────────────┐ "
  \echo " │ Do not close this window │ "
  \echo " └──────────────────────────┘ "
}

_diablo_teardown(){
  \echo " * Teardown.."
  ~/.config/openbox/unwine.sh
#  \echo " - cpufreq: Cooling down the processor"
#  \sudo \cpufreq-set --governor ondemand
  \echo " - Killing any lingering processes."
  \killall \
    xkill \
    explorer.exe \
    plugplay.exe \
    services.exe \
    winedevice.exe \
    wineserver \
    Agent.exe \
    Diablo\ III.exe \
    &> /dev/null
}


# --
# -- Actual stuff
# --

_diablo_setup
_diablo_run $@
\wait $wowpid &> /dev/null
_diablo_teardown
\echo " * Done."
