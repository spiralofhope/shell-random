#!/usr/bin/env  sh

# Find the oldest files in this directory and all subdirectories.



#:<<'}'   #  zsh
{
  echo .
  # Current directory only
  #\echo  *(.om[1])
  #\echo  *(om[1])
  #\echo  **/*(om[1])
}



#:<<'}'   #  
{
  \find . -type f -exec  \
    ` # change %Y to %X for the _accessed_ files `  \
    \stat -c '%Y %n' {} \;  |\
    \sort  -nr  |\
    ` # var= is the number of files to list.  This doesn't seem to work! `  \
    \awk -v var="10" 'NR==1,NR==var {print $0}'  |\
    while read t f; do
      d=$( date -d @$t "+%b %d %T %Y" )
      \echo  "$d -- $f"
    done
}



:<<'}'   #  
{
  # Just a single file
  DIR='.'
  find "$DIR" -type f -printf "%T@ %p\n"  |
  awk '
  BEGIN { recent = 0; file = "" }
  {
  if ($1 > recent)
    {
    recent = $1;
    file = $0;
    }
  }
  END { print file; }' |
  sed 's/^[0-9]*\.[0-9]* //'
}



#:<<'}'   #  Simple
{
  # -t is the newest first
  # ls -Art | tail -n1
  # Current directory:
#  \ls -lAt1r | tail -n1
  # Tree, last 10
  \ls -lAt1rR | tail -n10
}
