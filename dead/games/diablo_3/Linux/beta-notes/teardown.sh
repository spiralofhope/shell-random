#!/usr/bin/env  sh

# 2012-05-08

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
    Diablo\ III\ Beta
#    *Diablo\ III\ Beta\ Setup\.exe\ *
}

_wow_teardown

