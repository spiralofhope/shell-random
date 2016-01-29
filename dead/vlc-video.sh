# A normal player would start playing a new file when it's sent one.
# vlc decides to start a second process.  If it's told to not do that, then it will just ignore any subsequent attempts to play a new file.
# Therefore, I must kill vlc and start a new process.  Sigh.

# TODO: Get vlc to dump its pid to a file, then I can later read it and control it in daemon mode?

# Force it to quit
vlc vlc://quit

# Play the new file
nohup vlc "$1" >> /dev/null

echo $1
