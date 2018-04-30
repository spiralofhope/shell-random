#!/usr/bin/env  bash

# 2012-05-20


_wow_teardown(){
  \killall \
    xkill \
    explorer.exe \
    plugplay.exe \
    services.exe \
    winedevice.exe \
    wineserver \
    Agent.exe \
    Diablo-III-Beta-enUS-Setup.exe \
    Diablo\ III\ Beta\ Launcher.exe \
    Blizzard\ Launcher.exe \
    >> /dev/null 2>&1
  \killall --regexp \
    *Blizzard\ Launcher\\.exe*

  ~/.config/openbox/unwine.sh
}

_wow_teardown

