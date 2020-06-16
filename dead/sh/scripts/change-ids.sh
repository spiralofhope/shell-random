#!/usr/bin/env  sh


username='user'
userid='1001'
groupname='user'
groupid='1001'


\usermod  -u  "$userid"  "$username"
\groupmod  -g  "$groupid"  "$groupname"
