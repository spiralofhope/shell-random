#!/bin/zsh

# TODO:  have a config.wtf just for raiding, and summon it via this script with something like ./wow.sh raid

# Read in the configuration
\. $( \readlink -f $0 ).ini

_wow_die(){
  \echo " * ^c detected, killing WoW."
  _wow_teardown
}
trap _wow_die INT

_wow_teardown(){
  \echo " * Cleaning up.."

  \echo " * Cooling down the CPU for \"on demand\" performance."
  \cpufreq-set --governor ondemand

  \echo " * Restoring the mouse."
  \xsetroot -cursor_name left_ptr

  \echo " * Re-enabling original Openbox hotkeys."
  \cp --force $rc_normal $rc
  if ! [ $(whoami) = root ]; then
    \openbox --reconfigure
  else
    \su $user -c "\openbox --reconfigure"
  fi
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
  cache_files /home/$user
}
#test_cache_files
# Consider a variable for the editor.  I recall having poor luck with that in the past.
_open_wow_texts() {
  cache_files $wow_texts
  cd $wow_texts
  \su $user -c "\geany _wow.txt" &
  sleep 1
  for i in $wow_texts/*; do
    \su $user -c "\geany $i" &
    sleep 0.1
  done
  \su $user -c "\geany _wow.txt" &
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
  \rm --force $wow_log
  # Leaving it missing will cause problems.
  \touch $wow_log
}

# --

if ! [ $(whoami) = root ]; then
  \echo "You need to be root!"
  _wow_teardown
else

  \killall -9 unclutter
  #_hide_mouse
  _clear_combatlog

  if [ -z $1 ]; then
    \echo " * Launching Mangler (Ventrilo client) with auto-login."
    # Zomg plaintext login information!
    su $user -c "\mangler -s $mangler_ip:$mangler_port -u $mangler_user -p $mangler_pass" &

    _open_wow_texts
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
  \killall Wow.exe &> /dev/null

  \echo " * Heating up the CPU for maximum performance."
  \cpufreq-set --governor performance

  \echo " * Launching Wow.exe via wine."
  # padsp added to perhaps fix crackling audio.
  \su $user -c "\padsp \wine \"$wowdir\"/Wow.exe &> /dev/null" & \
    wowpid=$!
  #\echo "     WoW found at pid: " $wowpid
  #ps alx|grep padsp
  #ps alx|grep wine
  #ps alx|grep Wow.exe
  \renice -n -10 $wowpid &> /dev/null
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

fi
