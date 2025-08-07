#!/usr/bin/env  bash



# Doesn't actually have anything in there, as of 2014-05-23:
#\sudo  \add-apt-repository  ppa:bratherlui/seamonkey

# Also doesn't have anything
#   They suggest going to http://sourceforge.net/apps/mediawiki/ubuntuzilla/index.php?title=Main_Page
#\sudo  \add-apt-repository  ppa:joe-nationnet/seamonkey-dev



# Apparently echo -e is a bashism.  I can't get it to work when this script is shebanged as sh, even though it works at the commandline in sh.
\echo -e '\ndeb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main' |\
  \sudo  \tee  -a /etc/apt/sources.list > /dev/null

\sudo  \apt-key \
  adv \
  --recv-keys \
  --keyserver  keyserver.ubuntu.com C1289A29

\sudo  \apt-get  update
\sudo  \apt-get  install  seamonkey-mozilla-build
