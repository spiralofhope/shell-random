#!/usr/bin/env  sh



# Aumix is bugged.



settings="$HOME/.aumixrc.unmute"

aumix_settings_save() {
  # Save settings to ~/.aumixrc
  \aumix  -S
}

aumix_settings_load() {
  # Load settings from ~/.aumixrc
  # FIXME - while this raises the volume, as claimed by aumix -q, it does not unmute.
  \aumix  -L  >  /dev/null
}



if [ -e "$settings" ]; then
  \mv  --force  "$settings"  "$HOME/.aumixrc"
  aumix_settings_load
else
  aumix_settings_save
  \cp  "$HOME/.aumixrc"  "$settings"
  # BUG - aumix is bugged, dropping main or PCM to zero will permanently mute all audio.  Even if turned up, audio never returns.  FML.
  # main volume mute
  \aumix  -v 0
  # PCM mute
  \aumix  -w 10
fi
