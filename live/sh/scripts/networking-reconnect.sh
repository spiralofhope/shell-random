#!/usr/bin/env  sh
# Reconnect to networking
# Because the UI doesn't appear to have anything, and I can't be bothered to remember this command.
# Virtualbox/debian-10.1.0-amd64-xfce-CD-1.iso


# You can also get more information with:
# \ip  link  show
# \ip  a
# \cat  /proc/net/dev


\sudo  \dhclient  enp0s3

\echo  ''
\echo  ' * Note:  If on VirtualBox, you may have better luck disconnecting and reconnecting:'
\echo  '   <host>-home > Devices > Network > (Connect Network Adapter)'
\echo  ''
