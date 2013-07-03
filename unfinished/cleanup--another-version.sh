# This is my ISO preparation script from PCLinuxOS back in 2008-08-21

# Update all packages
# WARNING: In theory, updating can break things!
# Consider backing up before, and rebooting then testing after.
# I prefer to do this manually..
# apt-get autoclean && apt-get update && apt-get dist-upgrade

# Delete all files, but don't delete any directories:
find /var/cache/apt/ -name '*' -exec rm {} \;
find /var/log/ -name '*' -exec rm {} \;
find /var/state/apt/lists/ -name '*' -exec rm {} \;

# I have not tested this 'old kernels' cleanup:
# Clean up kernel headers and kernel modules from old kernels (if any)
KERNEL_VERSION=`uname -r`
OLDPWD=`pwd`
cd /usr/src
DELETE_HEADERS=`ls -1 /usr/src/|grep -i "linux-2*"|grep -v $KERNEL_VERSION`
rm -rf $DELETE_HEADERS
#
cd /lib/modules
DELETE_MODULES=`ls -1 /lib/modules/|grep -v $KERNEL_VERSION`
rm -rf $ DELETE_MODULES
cd $OLDPWD

# Remove everything out of /usr/share/doc except the HTML directory.
mv /usr/share/doc/HTML /;rm -rf /usr/share/doc/*;mv /HTML /usr/share/doc/

# Delete and recreate the guest account:
# if [TYPE != "BACKUP] then:
  userdel -r guest
  useradd -g guest -d /home/guest -s /bin/bash -c "Guest Account" -m -k /etc/skel -p guest guest
  # I'm not sure how to just make this run automatically with my preferences.
  nohup kcmshell privacy & > /dev/null
# fi

# Clean up after 'links'
cd /home/user/.links
rm -f cookies links.his
cd /home/root/.links
rm -f cookies links.his

# Clean up after 'Firefox 3'
cd /root/.mozilla/firefox/*.default
rm -rf Cache*
rm -f cookies.sqlite downloads.sqlite search.sqlite sessionstore.* formhistory.sqlite
cd minidumps;rm -rf *
#-
cd /home/user/.mozilla/firefox/*.default
rm -rf Cache*
cd minidumps;rm -rf *
rm -f cookies.sqlite downloads.sqlite search.sqlite sessionstore.* formhistory.sqlite

# Clean out the .thumbnails directory
rm -rf /root/.thumbnails/*
rm -rf /home/user/.thumbnails/*

# umount all partitions except the main partition
umount /mnt/*

# locate/slocate's database
updatedb

rm -f /home/user/.bash_history
rm -f /root/.bash_history
