#!/usr/bin/env  sh
#
# FIXME - Does none of this work with pure Dash?  Sigh.



#:<<'}'   # Change directory into a file's location.
{
  # I'd love to hijack 'cd', but that doesn't work.
  cdd() {
    if   [ ! -e "$1" ]; then
      \echo  'cdd: no such file or directory:'  $*
    elif [ -L "$1" ]; then
      \cd  $( \dirname  $( \realpath "$1" ) )
    else   # whatever else it happens to be.. just do whatever.
      \cd  "$*"
    fi
  }
}



#:<<'}'   #  Make and change into a directory:
{
  mcd() {
    directory="$1"
    if   [ -z "$1" ]; then
      directory="$( \date  +%Y-%m-%d )"
    elif [ -f "$1" ]; then   #  File
      directory="$( \dirname  "$1" )"
    fi
    # Silent errors:
    \mkdir  --parents  "$directory"
    \cd               "$directory"
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
      \head --lines=1
    # The actual list of stuff
    _df |\
      \tail --lines=+2  |\
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
      \tail -n +2  |\
      \head -n -2  |\
      \less  --RAW-CONTROL-CHARS  --quit-if-one-screen
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
