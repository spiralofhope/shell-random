#!/usr/bin/env  zsh

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
