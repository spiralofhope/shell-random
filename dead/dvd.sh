# ----------
# Play a DVD
# ----------

# Strange, gmplayer has a bug where I cannot summon it from X, but
# only from the commandline, unless I do this eject trick.  Hrm.
# eject /dev/dvd
# sleep 1
# eject -t /dev/dvd
# gmplayer -dvd-speed 1 dvd://1
# This one allows a menu, but only with mplayer..
mplayer -mouse-movements dvdnav://
# nohup kaffeine dvd:/ &> /dev/null
# kaffeine --dvd
eject /dev/sr0
sleep 10
eject -t /dev/sr0


# Having issues with only seeing a tiny clip?  Try..
# gmplayer -dvd-speed 1 dvd://1
# gmplayer -dvd-speed 1 dvd://2
# ...

