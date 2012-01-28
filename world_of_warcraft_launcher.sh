#!/usr/bin/env zsh

# padsp is from pulseaudio-utils (try task-pulseaudio)
# \rm -rf ~/.wine
# \padsp \winecfg
# don't bother with gecko.

# TODO:  have a config.wtf just for raiding, and summon it via this script with something like ./wow.sh raid

wowdir="/mnt/ssd/WoW/World of Warcraft"
# The default Openbox configuration file's location.
rc=$HOME/.config/openbox/rc.xml
# Unity Linux Alpha1
#sudo=(\gksu -u root)
#sudo_user=(\gksu -u user)

# Unity Linux Alpha1
sudo=(\su -c)
sudo_user=(\sh -c)

#sudo=(\sh -c)
#sudo_user=(\sh -c)

# --

rc_normal=${rc}-normal.xml
rc_wine=${rc}-wine.xml
wowconfig=$wowdir/WTF/Config.wtf
wow_texts=/mnt/ssd/WoW/texts

_wow_die(){
  \echo " * ^c detected, killing WoW."
  _wow_teardown
}
trap _wow_die INT

_wow_teardown(){
  \echo " * Cleaning up.."

  # Not installed on Unity Linux
  #\echo " * Cooling down the CPU for \"on demand\" performance."
  ## On Unity, there is `cpufreq-set` in cpufreqtools
  ## I need to install the amd cpufreq stuff I think..
  #\cpufreq-selector --governor ondemand

  \echo " * Restoring the mouse."
  \xsetroot -cursor_name left_ptr

  \echo " * Re-enabling original Openbox hotkeys."
  \cp --force $rc_normal $rc
  \openbox --reconfigure
  \echo " * Backing up any WoW configuration changes that I've made in-game."
  \echo "   Note that in case I screwed things up, there is a static copy kept"
  \echo "     as Config.wtf-WINE-backup"
  \cp --force $wowconfig          ${wowconfig}-WINE
  \echo " * Restoring whatever WoW configuration was there previously."
  \cp --force ${wowconfig}-previous $wowconfig
  \echo " * Killing any lingering processes."
  \killall \
    xkill \
    explorer.exe \
    plugplay.exe \
    services.exe \
    winedevice.exe \
    wineserver \
    Wow.exe \
    &> /dev/null
  \unclutter -root -idle 3 &> /dev/null &
  \echo " * fin."
  \echo ""
}

cache_files() {
  if [ -z "$1" ] || ! [ -z "$2" ] || ! [ -d "$1" ]; then
    echo "Needs one parameter, a directory"
    return
  fi
  for file in $1/*; do
    if ! [ -f $file ]; then
      continue
    fi
    cat "$file" >> /dev/null
  done
}
test_cache_files() {
  cache_files /home/user
}
#test_cache_files
# Consider a variable for the editor.  I recall having poor luck with that in the past.
_open_wow_texts() {
  cache_files $wow_texts
  cd $wow_texts
  \geany _wow.txt &
  sleep 1
  for i in $wow_texts/*; do
    \geany $i &
    sleep 0.1
  done
  \geany _wow.txt &
  cd -
  sleep 3
}

_hide_mouse() {
  echo " * Hiding the mouse"
  emptycursor_filename=/tmp/emptycursor-data.bmp
  
  emptycursor_data=$(cat <<'HEREDOC'
  #define nn1_width 16\n#define nn1_height 16\nstatic unsigned char nn1_bits[] = {\n0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,\n0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,\n0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};\n
  HEREDOC)
  
  \rm -f emptycursor-data.bmp
  \echo $emptycursor_data > $emptycursor_filename
  \xsetroot -cursor $emptycursor_filename $emptycursor_filename
  \rm -f emptycursor-data.bmp
}

_clear_combatlog() {
  # Blanking out the combat log because there's no other mechanism to trim it.  It can grow very large!
  log="/mnt/ssd/WoW/World of Warcraft/Logs/WoWCombatLog.txt"
  \rm --force $log
  # Leaving it missing will cause problems.
  \touch $log
}

# --

if [ -z $1 ]; then
  \echo " * Launching Mangler (Ventrilo client) with auto-login."
  # Zomg plaintext login information!
  \padsp \mangler -s xx:xx -u xx -p xx &

  _open_wow_texts

  \killall -9 unclutter
  \killall -9 unclutter

  _hide_mouse
  _clear_combatlog
fi

\echo " * Disabling conflicting Openbox hotkeys."
\cp --force $rc_wine $rc
\openbox --reconfigure

\echo " * Backing up existing WoW settings."
\cp --force $wowconfig      ${wowconfig}-previous
\echo " * Applying Wine-specific WoW settings."
\cp --force ${wowconfig}-WINE $wowconfig

\echo " * Escalating privileges..."
\echo " * Killing any existing/hung Wow.exe process.."
\echo "   ( note that this is not a kill -9 )"
$sudo \
  \killall Wow.exe &> /dev/null

# Last used under Ubuntu, not available / not downloaded for Unity Linux.
#\echo " * Heating up the CPU for maximum performance."
## $sudo dpkg-reconfigure gnome-applets
## cpufreq is probably a package that's pre-installed
## I can drop the cpufreq applet into my toolbar and use it there, or:
#\cpufreq-selector --governor performance

\echo " * Launching Wow.exe via wine."
# I'm $sudoing into the user to request the password,
# since I need $sudo later to do the renices.  It's
# much more simple this way.
# However, I do have $sudo earlier, so technically I
# don't need it here anymore.  It does no harm.
$sudo_user \
  \padsp \wine $wowdir/Wow.exe &> /dev/null & \
  wowpid=$!
  #\echo "   WoW is at pid: " $wowpid

# -----------
#\wine $wowdir/Wow.exe &> /dev/null & \
  #wowpid=$!

$sudo \
  \renice -n -10 $wowpid &> /dev/null
$sudo \
  \renice -n -10 `\pidof wineserver` &> /dev/null

#\echo " ┌──────────────────────────┐ "
#\echo " │ Do not close this window │ "
#\echo " └──────────────────────────┘ "
\echo " .--------------------------. "
\echo " : Do not close this window : "
\echo " \`--------------------------' "
\echo ""
\echo "To restore the mouse pointer, do:"
\echo "\xsetroot -cursor_name left_ptr"

\wait $wowpid &> /dev/null
\echo " * WoW has ended."
_wow_teardown
