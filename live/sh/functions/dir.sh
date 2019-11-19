# https://blog.spiralofhope.com/?p=895



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
