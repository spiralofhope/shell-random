#!/usr/bin/env  sh



\awk  -f stats.awk /etc/passwd


exit 0

echo LIST PASSWD AND SHADOW FILES TO CHECK FOR LAST DATE ACCESSED
echo

\cd  /etc
\ls  -l  *passwd* *shadow*
\cd  -



echo  
echo CHECK FOR USERS AND GROUPS THAT ARE EQUAL WITH ROOT
echo
\grep  ':00*:' /etc/passwd



echo 
echo CHECK FOR USERS WITH SHELL ACCESS
echo
\grep  bash /etc/passwd



echo
echo LIST THE LAST 20 LOGINS
echo
\last | \head -20



echo
echo CHECK THE HARD DRIVE SPACE
echo
\df  -h



echo
echo CHECK TO SEE IF HOSTS IN THE HOSTS TABLE ARE UP
echo
# Boy will this go through a hell of a lot.
# On Babun:
#   Access denied. Option -c requires administrative privileges.
# \awk  '/^[^#]/ {system("ping -c 1 "$1)}' < /etc/hosts

\awk  '/^[^#]/ {system("ping -n 1 "$1)}' < /etc/hosts



echo
echo CHECK WHO IS ACCESSING /
echo
\fuser  -vu  /



echo
echo CHECKING WHO IS USING THE MACHINE AT THE MOMENT
echo
\who
