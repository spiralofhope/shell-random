#!/usr/bin/env  sh
# Has (likely the same) problem as Brave, see `brave-firejail.sh`


# Firejail is its own sandboxing software
# For testing purposes:
\firejail \discord --no-sandbox $* > /dev/null &
#\firejail \bravediscord --no-sandbox > /dev/null 2>&1 &


# You may want to update the various launcher icons/menu items:
# sudo nano /usr/share/applications/discord.desktop
# /usr/bin/discord
# =>
# ~/l/path/discord


# This might be useful for some shells:
# disown
