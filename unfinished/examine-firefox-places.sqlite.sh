#!/usr/bin/env  zsh


# Goal:
#
#   - Given two installations of Firefox (a) and (b).
#   - Manually back up both bookmark databases, named as today's date and time such as 2015-03-11__13_00_00 .
#     --  Note: I have notes elsewhere on the date/time format generation.
#   - Create a subfolder in (b), named as today's date and time.  See above.
#   - Take all bookmarks from a specific subfolder, named as _outbox , in (a).
#   - Place those bookmarks into that date+time-named subfolder in (b), named as __ .
#   - Move all bookmarks from (a) into another subfolder, named trash.
#     --  This is for manual review and deletion once I'm confident this script works.  NOTE:  NEVER delete bookmarks, as some version change of Firefox may change things, silently break this script and stomp on everything.

# TODO - https://github.com/spiralofhope/shell-random/issues/1
#
# http://www.commandlinefu.com/commands/view/14088/get-your-firefox-bookmarks
#
#sqlite3 \
#  ~/.mozilla/firefox/*.[dD]efault/places.sqlite \
#  "SELECT strftime('%d.%m.%Y %H:%M:%S', dateAdded/1000000, 'unixepoch', 'localtime'),url \
#  FROM moz_places, moz_bookmarks \
#  WHERE moz_places.id = moz_bookmarks.fk \
#  ORDER BY dateAdded;"
#
# > Extracts yours bookmarks out of sqlite with the format:
# >   dateAdded|url


# Props to  http://id.motd.org/pivot/entry.php?id=22

# Test this snippet out, to avoid the for-loop:
#  select a.url, a.title from moz_places a, moz_bookmarks b where a.id=b.fk and b.parent=90;


# Tested 2014-02-23 on Lubuntu 13.10, updated recently.

#\sudo  \apt-get  install  sqlite3

# List all folders:
#\sqlite3  places.sqlite \
#  "select id,title from moz_bookmarks where type=2"

# Just grab one of them:
last_folder=$( \
\sqlite3  places.sqlite \
  "select id  from moz_bookmarks  where type=2" |\
  \tail  --lines=1
)
#echo $f

some_ids=$( \sqlite3  places.sqlite  "select fk  from moz_bookmarks  where parent="$last_folder )
#echo $some_ids

## Who the fuck knows why I have to do this echo trick..
#for i in $( \echo  $some_ids ) ; do
#  \sqlite3  places.sqlite \
#  "select url  from moz_places  where id="$i
#done



# Give complete info:
for i in $( \echo  $some_ids ) ; do
  \sqlite3  places.sqlite \
  "select *  from moz_places  where id="$i
done

# TODO - How do I learn the names of all the tables?
# TODO - Learn how to append a new bookmark.
# TODO - Will I be able to do this on a live-opened database?
