#!/usr/bin/env  sh
# List files, DOS-style like `dir`
# https://blog.spiralofhope.com/?p=895



#:<<'}'   
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
