#!/usr/bin/gawk -f
#
# Copyright (C) 2004 Edgewall Software
# Copyright (C) 2004 Daniel Lundin <daniel@edgewall.com>
#
# sjphone-ringer is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# sjphone-ringer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# Author: Daniel Lundin <daniel@edgewall.com>
#
# About sjphone-ringer
# --------------------
# At Edgewall, we use sjphone as our voip softphone of choice, and it works
# quite well. It does, however, lack a decent ringer and call notification to 
# alert you of an incoming phone call.
#
# sjphone-ringer is a simple wrapper hack for sjphone, allowing notification
# upon incoming calls. By default it uses the KDE knotify mechanism for visual
# display and aplay to play a ringer sound, but can easily be adapted to
# fit your needs.
#
# To install, edit the configuration variables below to match your system
# (particularly the SJPHONE_DIR) , and place the script in your $PATH.
#
# To run, simply run:  $ sjphone-ringer
#

BEGIN {
    SJPHONE_DIR="./"

    RINGFILE="~/.sjphone/ring.wav"
    RING="aplay -q " RINGFILE

    NOTIFY="dcop knotify default notify notify \
           'SJPhone - Incoming Call' \"%s\" '' '' 16 0"

    # -- No user-servicable parts below here -- #

    SJPHONE = sprintf("cd %s; script -a -f -c ./sjphone -; cd -",
		      SJPHONE_DIR)
    while (SJPHONE | getline) {
	print
	match($0, /^ *Incoming call from (.*) *$/, m)
	 if (m[1]) {
	     caller = m[1]
	 } else {
	     match($0, /^ * from (.*)$/, m)
	     if (m[1]) {
		 from = m[1]
	     } else {
		 match($0, /^ *(.* session using .*) *$/, m)
		 if (m[1]) {
		     sess = m[1]
		     t = strftime()
		     msg = sprintf("Call from %s\n%s\n%s\n%s",
				   caller, from, sess, t)
		     notify = sprintf(NOTIFY, msg)
		     system(notify)
 		     system(RING)
		 }
	     }
	 }
    }
}
