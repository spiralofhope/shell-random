#!/usr/bin/env  sh

# try restarting ALSA
# service alsa restart
## must be root



# Doing alsactl to store mixer settings...                        [  OK  ]
# no. (sound is being used by pid   7700))                        [FAILED]
# ALSA driver is already running.Doing alsactl to restore mixer se[  OK  ]

# It doesn't give a decent exit code.  Argh.
# So I'd have to get and process the text to get the pid.
