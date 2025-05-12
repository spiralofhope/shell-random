#!/usr/bin/env  sh
# Brave doesn't have a functional sandbox and I can't figure it out...


# Firejail is its own sandboxing software
# For testing purposes:
#\firejail \brave-browser --no-sandbox $* > /dev/null &
\firejail \brave-browser --no-sandbox > /dev/null 2>&1 &


# You may want to update the various launcher icons/menu items:
# sudo nano /usr/share/applications/brave-browser.desktop
# /usr/bin/brave-browser-stable
# =>
# ~/l/path/brave


# This might be useful for some shells:
# disown
