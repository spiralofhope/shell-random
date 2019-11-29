#!/usr/bin/env  sh
# youtube-dl
# A download helper for YouTube and other video hosts.
# https://youtube-dl.org/
# https://blog.spiralofhope.com/?p=41260



#` # I suspect this is important for an NTFS filesystem. `  \
#--restrict-filenames  \


#filename=$(  \
  #\youtube-dl  \
    #--get-filename  \
    #--output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
  #"$@"  \
#)
#echo $filename
#return 0


\youtube-dl  \
  --console-title  \
  --audio-format  best  \
  --write-description  \
  --write-info-json  \
  --write-annotations  \
  --write-all-thumbnails  --embed-thumbnail  \
  --all-subs  --embed-subs  \
  --add-metadata  \
  --no-call-home  \
  ` # Note that a base directory  ./  does not work (for subtitles) `  \
  --output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
  -f best  \
  "$@"


# TODO - detect control-c
#if [ $? -ne 0 ]; then return 1; fi

# Trailing periods are invalid on Windows; remove them:
#
# Testing:
# \rmdir **/* ; \rmdir * ; \mkdir  --parents  a/a.  b/b.  c/c  a/testing.one.  a/testing.two  a/testing.a.three.  a/testing.a.four
for directory in *.; do
  if [ -d "$directory" ]; then
    \mv  "$directory" "$(basename "$directory" .)"
  fi
done

for directory in *; do
  if [ -d "$directory" ]; then
    \cd  "$directory"  > /dev/null
    for subdirectory in *.; do
      if [ -d "$subdirectory" ]; then
        \mv  "$subdirectory" "$(basename "$subdirectory" .)"
      fi
    done
    \cd  -  > /dev/null
  fi
done

# I have no idea how to use youtube-dl's --output to fix the date format, so do it manually:
# Testing:
# \mkdir  --parents  a  '12345678 - one'  '1234-5678 - two'  '1234-56-78 - three'  a/a  'a/12345678 - one'  'a/1234-5678 - two'  'a/1234-56-78 - three'
for directory in *; do
  if [ -d "$directory" ]; then
    \cd  "$directory"  > /dev/null

    # Testing:
    # \rmdir **/* ; \rmdir * ; \mkdir  --parents  a  '12345678 - one'  '1234-5678 - two'  '1234-56-78 - three'
    for subdirectory in *; do
      if [ -d "$subdirectory" ]; then
        target=$( \echo  "$subdirectory" | \sed 's/\(^[0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
        if ! [ "$subdirectory" = "$target" ]; then
          \mv  "$subdirectory"  "$target"
        fi
      fi
    done

    \cd  -  > /dev/null
  fi
done
