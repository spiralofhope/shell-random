#!/usr/bin/env  sh

# Adjust the structure of a previous-generation of a cache.
# Update the description.
# Download the latest comments.


#DEBUG='true'



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$*"  >&2
  fi
}


# Refresh subdirectories:
# for i in *; do if [ -d "$i" ]; then cd "$i"; echo "$PWD" ; printf "\033]0;...\007" ; youtube-refresh.sh; cd - > /dev/null; printf '\n\n' ; fi; done ; cd .
# Note that, although rare, you might get an error when downloading comments; check your scrollback buffer and re-try as needed.
if [ "$1" = 'all' ]; then
  for i in *; do
    if ! [ -d "$i" ]; then continue; fi
    \cd  "$i"  ||  return  $?
    \echo  "$PWD"
    # shellcheck  disable=1117
    #   This formatting is intentional, to manipulate the terminal's title.
    printf  "\033]0;...\007"
    youtube-refresh.sh
    \cd  -  > /dev/null  ||  return  $?
  done
  \cd  .  ||  return  $?
  return
fi


# Only process the last n directories:
# \ls -1 --escape | tail --lines=5 | while read i; do if [ -d "$i" ]; then cd "$i"; echo "$PWD"; printf "\033]0;...\007" ; youtube-refresh.sh; cd - > /dev/null ; fi; done; cd .
if   [ $# -eq 1 ]; then
  if ! is-string-a-number？.sh  "$1"; then return  1; fi
  lines="$1"
  #echo _${lines}_
  #
  # shellcheck  disable=2162
  #  `read` doesn't work with -r
  #    I don't know why.
  \find  .  -maxdepth  1  -type d  \
  |  \tail  --lines="$lines"  \
  |  \
  while read  i; do
    \cd  "$i"  ||  return  $?
    \echo  "$PWD"
    # shellcheck  disable=1117
    #   This formatting is intentional, to manipulate the terminal's title.
    printf  "\033]0;...\007"
    youtube-refresh.sh
    \cd  -  > /dev/null  ||  return  $?
  done
  \cd  .  ||  return  $?
  return
fi



fix_files() {
  if [ ! -f 'v.info.json' ]; then
    # Probably nothing is named correctly..
    \mv  ./*.annotations.xml  'v.annotations.xml'  2>  /dev/null
    \mv  ./*.info.json        'v.info.json'        2>  /dev/null
    \mv  ./*.xml              'v.xml'              2>  /dev/null
    \mv  ./*.jpg              'v.jpg'              2>  /dev/null
    \mv  ./*.mkv              'v.mkv'              2>  /dev/null
    \mv  ./*.mp4              'v.mp4'              2>  /dev/null
    \mv  ./*.webm             'v.webm'             2>  /dev/null
    \mv  ./*.aac              'v.aac'              2>  /dev/null
    \mv  ./*.opus             'v.opus'             2>  /dev/null
    \mv  ./*.m4a              'v.m4a'              2>  /dev/null
  fi
  #
  if [ -f 'v_4.webp' ]; then
    _debug  ' * Deleting extraneous thumbnails.'
    \rm  --force  v_*.jpg
  fi
  #
  if [ -f 'v_3.jpg' ]; then
    _debug  ' * Deleting extraneous thumbnails.'
    \rm  --force  v_0.jpg
    \rm  --force  v_1.jpg
    \rm  --force  v_2.jpg
  fi
  #
  if [ -f 'v_4.jpg' ]; then
    _debug  ' * Deleting extraneous thumbnails.'
    \rm  --force  v_3.jpg
  fi
  #
  if [ -f 'v_orig.jpg' ]; then
    \rm  --force  'v_large.jpg'
    \rm  --force  'v_medium.jpg'
    \rm  --force  'v_small.jpg'
    \rm  --force  'v_thumb.jpg'
    \mv  'v_orig.jpg'  'v_4.jpg'
  fi
  #
  # The old date format which did not have the date of download.

  for f in ./comments-*.csv; do
    [ -e "$f" ] || break
    for i in comments-*.csv; do
      #end=$(( ${#i} - 4 ))
      #youtube_id=$( string-fetch-character-range.sh  10  "$end"  "$i" )
      #date='2020-08-02 06։04'
      # e.g. 
      #   2020-08-01 23:12:43.050756813 -0700
      # Unfortunately it looks like I can't fetch the creation date.
      #   Modification ought to do, and tagging ytcs0 will tell me that it's not trustworthy.
      date=$( \stat  --format='%y'  "$i" )
      date_before="$( string-fetch-character-range.sh   1  13 "$date" )"
      date_after="$(  string-fetch-character-range.sh  15  16 "$date" )"
      # ։ is not a colon
      date="${date_before}։${date_after}"
      filename_new="comments - $date.ytcs0.csv"
      _debug  "$filename_new"
      \mv  "$i"  "$filename_new"
    done
  done
  #
  # Mostly-copypasta from above, because I'm lazy.
  for f in ./comments-*.json; do
    [ -e "$f" ] || break
    for i in ./comments-*.json; do
      date=$( \stat  --format='%y'  "$i" )
      date_before="$( string-fetch-character-range.sh   1  13 "$date" )"
      date_after="$(  string-fetch-character-range.sh  15  16 "$date" )"
      date="${date_before}։${date_after}"
      filename_new="comments - $date.ytcs0.json"
      _debug  "$filename_new"
      \mv  "$i"  "$filename_new"
    done
  done
  #
  # Remove the youtube_id from the filename, to keep it short:
  # shellcheck  disable=1001
  for f in ./comments\ \-\ *\ \-\ *.ytcs?.json; do
    [ -e "$f" ] || break
    # shellcheck  disable=1001
    for i in comments\ \-\ *\ \-\ *.ytcs?.json; do
      end="$( string-fetch-character-range.sh  26  53 "$i" )"
      filename_new="comments - $end"
      \mv  "$i"  "$filename_new"
    done
  done
}



fix_directory() {
  directory_previous="$( \basename  "$PWD" )"
  #_debug  "$directory_previous"
  target_subdirectory="$directory_previous"


  replace_characters() {
    target_subdirectory=$( string-replace-character.sh  "$1"  "$2"    "$target_subdirectory" )
  }
  replace_characters  '?'  '？'
  replace_characters  ':'  '։'
  replace_characters  '"'  '‟'
  replace_characters  '/'  '∕'
  replace_characters  '*'  '★'


  # These don't solve my problem..
  replace_characters  '💝'  '_'
  # Cyrillic script
  replace_characters  'Ч'  'Ch'
  replace_characters  'Ш'  'Sh'
  replace_characters  'Щ'  'Sht'
  replace_characters  'Ю'  'Yu'
  replace_characters  'Я'  'Ya'
  replace_characters  'Ж'  'Zh'
  replace_characters  'А'  'A'
  replace_characters  'Б'  'B'
  replace_characters  'В'  'V'
  replace_characters  'Г'  'G'
  replace_characters  'Д'  'D'
  replace_characters  'Е'  'E'
  replace_characters  'З'  'Z'
  replace_characters  'И'  'I'
  replace_characters  'Й'  'Y'
  replace_characters  'К'  'K'
  replace_characters  'Л'  'L'
  replace_characters  'М'  'M'
  replace_characters  'Н'  'N'
  replace_characters  'О'  'O'
  replace_characters  'П'  'P'
  replace_characters  'Р'  'R'
  replace_characters  'С'  'S'
  replace_characters  'Т'  'T'
  replace_characters  'У'  'U'
  replace_characters  'Ф'  'F'
  replace_characters  'Х'  'H'
  replace_characters  'Ц'  'C'
  replace_characters  'Ъ'  'A'
  replace_characters  'Ь'  'I'
  replace_characters  'Ы'  'Y'
  replace_characters  'ы'  'y'
  _debug  "$target_subdirectory"


  directory_rename_if_tmp() {
    string="$*"
    #
    first_four=$( string-fetch-character-range.sh  1  4  "$string" )
    #
    # I'm assuming the rest of the directory was created with a name like "tmp.7kNoQjCSYn"
    if [ "$first_four" = 'tmp.' ]; then
      # FIXME?
      input_filename='v.info.json'
      # This is hardcoded to search for "fulltitle" because I can't figure out how to adjust search-json.sh
      result=$( \grep  --only-matching  --perl-regexp  '"fulltitle":.*?[^\\]",'  "$input_filename" )
      length=$(( ${#result} - 2 ))
      string=$( string-fetch-character-range.sh  15  $length  "$result" )
    fi
    \echo  "$string"
  }
  target_subdirectory=$( directory_rename_if_tmp  "$target_subdirectory" )
  _debug  "$target_subdirectory"

  prepend_date_if_absent() {
    string="$*"
    #
    if ! \
      is-string-a-date？.sh  "$( string-fetch-character-range.sh   1   10  "$string" )"
    then
      convert_numbers_into_date() {
        string="$*"
        #
        yyyy=$( string-fetch-character-range.sh   1  4  "$string" )
        mm=$(   string-fetch-character-range.sh   5  6  "$string" )
        dd=$(   string-fetch-character-range.sh   7  8  "$string" )
        \echo  "${yyyy}-${mm}-${dd}"
      }
      upload_date=$( search-json.sh  'upload_date'  'v.info.json' )
      upload_date=$( convert_numbers_into_date  "$upload_date" )
      _debug  "$upload_date"
      \echo  "$upload_date - $string"
    else
      \echo  "$string"
    fi
  }
  target_subdirectory=$( prepend_date_if_absent  "$target_subdirectory" )
  _debug  "$target_subdirectory"


  string_length_maximum=59
  string_to_append='…'
  string="$target_subdirectory"
  target_subdirectory=$( string-truncate-and-append.sh  "$string_length_maximum"  "$string_to_append"  "$string" )
  _debug  "$target_subdirectory"

  if [ ! "$directory_previous" = "$target_subdirectory" ]; then
    # Note that if the file already exists, there is no way to silence the warning:
    :>                     'original_directory.txt'
    \basename  "$PWD"  >>  'original_directory.txt'
    \cd  ../  ||  return  $?
    \mv  "$directory_previous"  "$target_subdirectory"  ||  return  $?
    \cd  "$target_subdirectory"  ||  return  $?
  fi
}



fix_description() {
  # Backup an old one if it's there.
  # .. but don't force it.
  \mv  ./*.description  'v.description.old.txt'  2>  /dev/null
  #
  # Re-get v.description
  # For reasons unknown I must pause a moment for the program to work properly..
  sleep  1
  if  !  \
    youtube-download-description.sh
  then
    \echo  '----------------------------------------------------------'
    \echo  "ABORTING on directory:"
    \echo  "$PWD"
    \echo  '----------------------------------------------------------'
    exit  $?
  fi
}



update_comments() {
  youtube-download-comments.sh
}



fix_files
fix_directory
fix_description
update_comments
