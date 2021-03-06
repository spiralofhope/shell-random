#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
#   (I like using backslashes)



# Download YouTube and other videos.
#
# Uses youtube-dl:
#   https://youtube-dl.org/
#   https://blog.spiralofhope.com/?p=41260
#
# Note that you might want to switch to youtube-dlc (and symlink to it) if there are any problems with youtube-dl:
#   https://github.com/blackjack4494/youtube-dlc
#
# Requires my `search-json`.
# Optionally uses several other of my scripts.
#
# YouTube's supported subtitle and closed caption files:
#   https://support.google.com/youtube/answer/2734698


# FIXME - Check that the dates are UTC and flag them as such. (not that it matters much)

# TODO - Try this:
#   https://stackoverflow.com/questions/31631535
#   -f ("bestvideo[width>=1920]"/bestvideo)+bestaudio/best

# TODO - Confirm that --batch-file will work for the files generated by `youtube-download-video-list.sh`

# TODO - investigate
    #How do I download only new videos from a playlist?
      #  >  Use download-archive feature. With this feature you should initially download the complete playlist with --download-archive /path/to/download/archive/file.txt that will record identifiers of all the videos in a special file. Each subsequent run with the same --download-archive will download only new videos and skip all videos that have been downloaded before. Note that only successful downloads are recorded in the file.

# TODO - If downloading from a list (when implemented), do:
#  --sleep-interval      min
#  --max-sleep-interval  max


# FIXME -- cookies interferes with other things? (reported by past self)

#cookie_file="$HOME/netscape-cookies.txt"
#DEBUG='true'



#:<<'}'   #  For `autotest.sh`
{
  if [ $# -eq 0 ]; then
    # Pass example parameters to this very script:
    # This is the oldest YouTube video:
    #"$0"  'jNQXAC9IVRw'                                                --skip-download
    #"$0"  'https://youtu.be/jNQXAC9IVRw'                               --skip-download
    #"$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw'                --skip-download
    #"$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw#me-at-the-zoo'  --skip-download

    # Testing with a login required...
    # TODO - Upload my own test, so I can rely on its existence.
    #"$0"  'ufH4DaUxBbA'                                                --skip-download

    return
  fi

  # TODO - instructions
  #if   [ "$#" -ne 1 ]; then return  1; fi
}



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$@"  >&2
  fi
}


# INT is ^C
trap control_c INT
control_c()
{
  \echo  'control-c detected.'
  exit  0
}



case  "$#"  in
  0)
    # I'm just going to use 0 for autotest anyway..
    \youtube-dl
    exit  0
  ;;
  2)
    if [ "$2" = '-F' ]; then
      \youtube-dl  \
        "$@"
      exit  0
    fi
  ;;
esac


# taken from  `replace-basename.sh`
_basename() {
  dir=${1%${1##*[!/]}}
  dir=${dir##*/}
  dir=${dir%"$2"}
  printf '%s\n' "${dir:-/}"
}


# taken from  `replace-dirname.sh`
_dirname() {
  dir=${1:-.}
  dir=${dir%%"${dir##*[!/]}"}
  [ "${dir##*/*}" ] && dir=.
  dir=${dir%/*}
  dir=${dir%%"${dir##*[!/]}"}
  printf '%s\n' "${dir:-/}"
}



video_id="$1"
shift



cookie_file=${cookie_file=''}
if [ ! "$cookie_file" = '' ]  \
&& [ ! -e "$cookie_file" ]
then
  \echo  'cookie file not found'
  exit  1
fi



determine_directories(){
  # Learn the directory structure we'll be working within:
:<<'}'   #  Write the json and get the data directly.
{
  # `search-json.sh` can be very slow; consider using another program to do this.
  # With this, you wouldn't need to initiate another youtube-dl request with fetch_id(), but that is rarely used.
  # You can get additional data from the json file early on, if that's useful to you.
  temporary_file="/tmp/my_temporary_file.$$"
  \youtube-dl  \
    --write-info-json  \
    --no-call-home  \
    --output  "$temporary_file"  \
    --skip-download  \
    --  \
    "$video_id"
  __="$temporary_file".info.json
  uploader=$(  search-json.sh  'uploader'   "$__" )  ;  _debug  "uploader:   $uploader"
  fulltitle=$( search-json.sh  'fulltitle'  "$__" )  ;  _debug  "fulltitle:  $fulltitle"
  # (You can extract additional information here)
  #id=$( search-json.sh  'id'         "$__" )  ;  _debug  "fulltitle:  $fulltitle"
  \rm  --force  --verbose  "$temporary_file"
}
  target=$(  \
    \youtube-dl  \
      --get-filename  \
      --output  '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
      "$@"  \
      --  \
      "$video_id"
  )
  _debug  "target:               $target"
  target_directory="$(    _dirname  "$( _dirname  "$target" )" )"
  target_subdirectory="$( _basename "$( _dirname  "$target" )" )"
  #
  # Remove 1-3 trailing periods
  #   (They are invalid on NTFS)
  target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
  target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
  target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
  # TODO - remove any other invalid characters
  #   See `youtube-refresh.sh`
  replace_characters() {
    target_subdirectory=$( string-replace-character.sh  "$1"  "$2"    "$target_subdirectory" )
    target_directory=$(    string-replace-character.sh  "$1"  "$2"    "$target_directory" )
  }
  # Not working.. so I'll just intelligently use --restrict-filenames
  #replace_characters  'Ø'  'O'
  #replace_characters  '/'  '∕'


  _debug  "target_directory:     $target_directory"
  _debug  "target_subdirectory:  $target_subdirectory"


  # I have no idea how to use youtube-dl's --output to fix the date format, so I define the directory manually.
  # 20170515  =>  2017-05-15
  # TODO - replace \sed
  target_subdirectory=$( \echo  "$target_subdirectory"  |  \sed  's/\(^[0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
  _debug  "target_subdirectory:  $target_subdirectory"



  if_long_then_truncate_and_append() {
    string_length_maximum="$1"
    shift
    # $2*
    # shellcheck  disable=2124
    #   (yes, I mean to do this)
    string="$@"
    string_length=${#string}
    if [ "$string_length" -gt "$string_length_maximum" ]; then
      append='…'
    fi
    __=$( string-truncate.sh  "$string_length_maximum"  "$string" )
    \echo  "$__$append"
  }
  target_directory="$(     if_long_then_truncate_and_append  29  "$target_directory"    )"
  target_subdirectory="$(  if_long_then_truncate_and_append  59  "$target_subdirectory" )"
  _debug  "$target_directory"
  _debug  "$target_subdirectory"
}


determine_directories  "$@"
if [ ! -d "$target_directory" ]; then
  if  !  \
    \mkdir  --parents  --verbose  "$target_directory"
  then
    \echo  "Directory creation failed.  Restricting filenames.."
    determine_directories  "$@"  --restrict-filenames
    if [ ! -d "$target_directory" ]; then
      \mkdir  --parents  --verbose  "$target_directory"  || exit  $?
    fi
  fi
fi
target_directory_proved_good="$target_directory"


# From  `string_fetch_last_character.sh`  :
string_fetch_last_character() {
  string_length=${#string}
  string_last_character="$*"
  i=1
  until [ $i -eq "$string_length" ]; do
    string_last_character="${string_last_character#?}"
    i=$(( i + 1 ))
  done
  printf  '%s'  "$string_last_character"
}


# From  `is-character-a-number？.sh`  :
is_character_a_number() {
  character=$*
  case $character in
    [0-9])  return  0  ;;
    *)      return  1  ;;
  esac
}



does_underscore_directory_exist() {
  # I want to avoid a duplicate $target_subdirectory that is:
  #   yyyy-mm-dd - _
  # Under unusual circumstances like having a Chinese video name,  --restrict-filenames  will only suggest an underscore ( _ ).
  # This may create a duplicate directory for a unique video
  # This is because YouTube does not provide the upload date *and time*, which would always be unique.
  string="$*"
  #
  if [ ${#string} -eq 14 ]  \
  && [ "$( string_fetch_last_character  "$target_subdirectory" )" = '_' ]; then
    _debug  "underscore directory DOES exist"
    return  0
  else
    _debug  "underscore directory does NOT exist"
    return  1
  fi
}



fetch_id() {
  \youtube-dl  \
    --write-info-json  \
    --no-call-home  \
    --output  'temporary'  \
    --skip-download  \
    --  \
    "$video_id"

  id=$( search-json.sh  'id'  'temporary.info.json' )
  \rm  --force                'temporary.info.json'
}



if [ ! -d "$target_directory/$target_subdirectory" ]; then
  if  !  \
    \mkdir  --verbose  "$target_directory/$target_subdirectory"
  then
    \echo  "Subdirectory creation failed.  Restricting filenames.."
    determine_directories  "$@"  --restrict-filenames
    target_directory="$target_directory_proved_good"
    if  does_underscore_directory_exist  "$target_subdirectory"; then
      # yyyy-mm-dd - _
      # Append the video's id.
      # This allows the same video to be downloaded a second time without creating a new _ directory.
      fetch_id
      target_subdirectory="${target_subdirectory}_${id}"
    fi
    \mkdir  --verbose  "$target_directory/$target_subdirectory"
  fi
fi

\cd  "$target_directory/$target_subdirectory"  ||  exit  $?

\echo  "$target_directory/$target_subdirectory"


# Previously..
#    ` # Note that a base directory  ./  does not work (for subtitles) `  \
#    --output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
#
#` # I suspect this is important for an NTFS filesystem. `  \
#--restrict-filenames  \
#
#:<<'}'   #  Download most things
{
  if [ "$cookie_file" = '' ]; then
    \youtube-dl  \
      --console-title  \
      --audio-format  best  \
      --write-info-json  \
      --write-annotations  \
      --write-all-thumbnails  --embed-thumbnail  \
      --all-subs  --embed-subs  \
      --add-metadata  \
      --no-call-home  \
      --output  'v.%(ext)s'  \
      --format  'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio'  \
      --merge-output-format mp4  \
      "$@"  \
      --  \
      "$video_id"
  else
    _debug  'using cookies'
    \youtube-dl  \
      --cookies="$cookie_file"  \
      --console-title  \
      --audio-format  best  \
      --write-info-json  \
      --write-annotations  \
      --write-all-thumbnails  --embed-thumbnail  \
      --all-subs  --embed-subs  \
      --add-metadata  \
      --no-call-home  \
      --output  'v.%(ext)s'  \
      --format  'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio'  \
      --merge-output-format mp4  \
      "$@"  \
      --  \
      "$video_id"
  fi
}



#:<<'}'   #  Delete extraneous thumbnails, if any.
{
  _debug  ' * Deleting extraneous thumbnails.'
  youtube-dl_delete-extraneous-thumbnails.sh
}



if [ ! "$cookie_file" = '' ]; then
  \rm  --force  "$cookie_file"
fi



#if  [ "$DEBUG" = 'true' ] || \
    #[ $# -eq 2 ] && [ "$2" = '-F' ]; then
  #exit
#fi



#:<<'}'   #  Create a Windows-compatible .lnk (web page link) to the source
{
  youtube-dl_create-url.sh
}



extractor="$( \search-json.sh  'extractor'  v.info.json )"



#:<<'}'   #  Description
{
  if [ "$extractor" = 'youtube' ]; then
    # For some stupid reason the description file won't be properly downloaded if placed in the youtube-dl command.
    # But I ended up pushing it into its own script anyway..
    _debug  ' * Downloading the description...'
    youtube-download-description.sh
  fi
}



#:<<'}'   #  Comments
{
  if [ "$extractor" = 'youtube' ]; then
    _debug  ' * Downloading the YouTube comments...'
    source_video_id="$( \search-json.sh  'id'  v.info.json )"
    youtube-download-comments.sh  "$source_video_id"
  fi
}



\echo  ''
\echo  ' * Finished with:'
\echo  "  \"$target_directory/$target_subdirectory\""
\echo  ''





:<<'}'   #  Get everything separately
        # This might be more reliable (maybe videos have a slash in their name?), but it's slower and multiple scrapes might piss YouTube off.
  target_directory=$(  \
    \youtube-dl  \
      --get-filename  \
      --output '%(uploader)s'  \
      "$@"  \
      --  \
      "$video_id"
  )
  target_subdirectory=$(  \
    \youtube-dl  \
      --get-filename  \
      --output '%(upload_date)s - %(title)s'  \
      "$@"  \
      --  \
      "$video_id"
  )
  #target_files=$(  \
    #\youtube-dl  \
      #--get-filename  \
      #--output '%(title)s.%(ext)s'  \
      #"$@"  \
      #--  \
      #"$video_id"
  #)
}
