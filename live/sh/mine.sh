#!/usr/bin/env  sh



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



:<<'}'   #  List files, DOS-style like `dir`
#  FIXME: I don't understand why I cannot call this ls()
# OLD:
{
  dir() {
    \ls \
      -1 \
      --almost-all \
      --color=always \
      --group-directories-first \
      --no-group \
      --quoting-style=shell \
      --size \
      "$@"  |\
        \less \
          --raw-control-chars \
          --no-init \
          --QUIT-AT-EOF \
          --quit-on-intr \
          --quiet
      ` # `
  }
}



#:<<'}'   #  List files, DOS-style like `dir`
{
  #  Works well, though it has various dependencies.  So what.
  dir() {
    \tree  -a  -C  -i  -L 1  |\
      \tail -n +2  |\
      \head -n -2  |\
      \sort  |\
      \less  --RAW-CONTROL-CHARS  --quit-if-one-screen
  }
}



#:<<'}'   #  List files, DOS-style like `dir`, with all information.
{
  #  Works well, though it has various dependencies.  So what.
  dira() {
    \tree  -pugDF  -a  -C  -i  -L 1  |\
      \tail -n +2  |\
      \head -n -2  |\
      \sort  |\
      \less  --RAW-CONTROL-CHARS  --quit-if-one-screen
  }
}



#:<<'}'   #  List directories, DOS-style like `dir /ad`
{
  #  Works well, though it has various dependencies.  So what.
  lsd() {
    \tree  -a  -C  -d  -i  -L 1  |\
      \tail -n +2  |\
      \head -n -2  |\
      \sort  |\
      \less  --RAW-CONTROL-CHARS  --quit-if-one-screen
  }
}
alias ddir=lsd



#:<<'}'   #  List directories, DOS-style like `dir /ad`, with all information.
{
  lsda() {
    #  Works well, though it has various dependencies.  So what.
    #  -Q  will add double quotes around everything.
    \tree  -pugDF  -a  -C  -d  -i  -L 1  |\
      \tail -n +2  |\
      \head -n -2  |\
      \sort  |\
      \less  --RAW-CONTROL-CHARS  --quit-if-one-screen
  }
}
alias ddira=lsda
