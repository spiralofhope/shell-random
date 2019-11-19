#!/usr/bin/env  sh
#
# FIXME - Does none of this work with pure Dash?  Sigh.



#:<<'}'   # Change directory into a directory-symbolic-link's real location, or a file's directory.
{
  # I'd love to hijack 'cd' directly using cd(), but that doesn't work.
  cdd() {
    local  target="$( \realpath "$*" )"
    if   [ -L "$*" ] && [ -d "$target" ] ; then  \cd  "$target"
    elif                [ -f "$target" ] ; then  \cd  $( \dirname  "$target" )
    else                                         \cd  "$*"
    fi
  }
}



#:<<'}'   #  Make and change into a directory:
{
  mcd() {
    directory="$@"
    if   [ -z "$1" ]; then
      directory="$( \date  +%Y-%m-%d )"
    elif [ -f "$*" ]; then   #  File
      directory="$( \dirname  "$@" )"
    fi
    # Silent errors:
    \mkdir  --parents  "$directory"
    \cd                "$directory"
  }
}



#:<<'}'   #  A nicer `df`
{
  #  This used to have  --exclude-type supermount
  #alias  df='\df  --human-readable'
  _df_sorted(){
    _df() {
      \df  --human-readable  --exclude-type tmpfs  --exclude-type devtmpfs
    }
    # The text at the top
    _df |\
      \head --lines='1'
    # The actual list of stuff
    _df |\
      \tail --lines='+2'  |\
      \sort --key=${1}
  }
}



#:<<'}'   #  youtube-comment-scraper
{
  ytcs() {
    if [ -n "$1" ]; then
      source_video_id="$1"
      \echo  " * Downloading comments..."
  #    \youtube-comment-scraper  --format csv  "$source_video_id"  >  comments-"$source_video_id".csv
      \youtube-comment-scraper  --format csv  --outputFile comments-"$source_video_id".csv  "$source_video_id"
    else
      \youtube-comment-scraper  "$@"
    fi
  }
}



#:<<'}'   #  List files, DOS-style like `dir`
# TODO? - Allow the user to pass a wildcard to restrict the listing.
{
  dir_tools(){
    #  Works well, though it has various dependencies.  So what.
    #  -Q  will add double quotes around everything.
    \tree  $@  -C  -i  -L 1  --dirsfirst  |\
      \tail --lines='+2'  |\
      \head --lines='-2'  |\
      \less  --RAW-CONTROL-CHARS  --quit-if-one-screen  --QUIT-AT-EOF
  }
  dir() {
    if   [ "$1" == "/ad" ] || [ "$1" == "/AD" ]; then  dir_tools  -ad  -pugDF
    elif [ "$1" == "/a"  ] || [ "$1" == "/A"  ]; then  dir_tools  -ah  -pugDF
    elif [ "$1" == "/d"  ] || [ "$1" == "/D"  ]; then  dir_tools  -d
    else                                               dir_tools
    fi
  }
}
alias DIR='dir $@'
alias dir/a='dir /a'
alias dir/ad='dir /ad'
alias dir/d='dir /d'


#:<<'}'  #  4DOS-style dir, using a descript.ion file
{
  # TODO - Do everything according to $LS_COLORS
  _ddir() {
      local  esc=''
      local  boldon="${esc}[1m"
      local  boldoff="${esc}[22m"
      local  reset="${esc}[0m"
      local  blue="${esc}[34m"
      local  cyan="${esc}[36m"
      local  grey="${boldoff}${esc}[37m"

      # FIXME - this is slow because it's re-reading the description for every single file.
      #   Read the descript.ion file into memory
      
      _get_description() {
        if [ ! -f 'descript.ion' ]; then return; fi
        #\echo  processing $*
        file_to_match="$*"
        while IFS='' \read -r line; do
          # TODO - support one or more tabs
          # Before three or more spaces
          local  line_file=$( \echo "$line" | awk -F'\ \ \ +' '{print $1}' )
          # After three or more spaces
          local  line_text=$( \echo "$line" | awk -F'\ \ \ +' '{print $2}' )
          if [ "$line_file"    == "$file_to_match" ]  ||\
             [ "$line_file"'/' == "$file_to_match" ]       ` # directory ` ;\
          then
            description="   $line_text"
          fi
        done < 'descript.ion'
      }

    _ddir_process(){
      local  description=''
      if [ -L "$*" ]; then
        # overrides color
        \echo  -n "$boldon$cyan"
        \echo  -n  "$*"
      else
        \echo  -n  "$*"
      fi
      \echo  -n  "$reset"
      _get_description  "$*"
      \echo     "$description"
    }

    for i in *; do
      if [ -d "$( \realpath "$i" )" ]; then
        \echo  -n  "$boldon$blue"
        _ddir_process "$i"
      fi
    done
    for i in .*; do
      if [ -d "$i" ]; then
        _ddir_process "$i"
      fi
    done
    for i in *; do
      if [ ! -d "$i" ]; then
        _ddir_process "$i"
      fi
    done
    for i in .*; do
      if [ ! -d "$i" ]; then
        _ddir_process "$i"
      fi
    done
  }
  ddir(){
    _ddir "$*"  |\
      \head --lines='-1'  |\
      \less  --RAW-CONTROL-CHARS  --quit-if-one-screen  --QUIT-AT-EOF
  }
}
