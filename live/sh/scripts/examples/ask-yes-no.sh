#!/usr/bin/env  sh

# https://stackoverflow.com/questions/226703/_/27875395#27875395

# You may wish to supplement this by trapping INT to force 'n', see `trapping-signals.sh`



#:<<'}'  {
_askyesno()  {
  \echo  '[y/N]'
  \read _
  # Ignore capslock with:
  #if [ "$_" != "${_#[Yy]}" ] ;then 
  if [ "$_" = 'y' ] ;then 
    \echo  'y'
  else
    \echo  'n'
  fi
}



#:<<'}'
_askyesno()  {
  \echo  "$1"
  finish='-1'
  read answer
  while [ "$finish" = '-1' ]; do
    finish="1"
    if [ "$answer" = '' ];
    then
      answer=''
    else
      case $answer in
        y | Y | yes | YES )
          answer='y'
        ;;
        n | N | no | NO )
          answer='n'
        ;;
        *)
          finish='-1'
          \echo  'Invalid response'
          read answer
       ;;
       esac
    fi
  done
  \echo  "The answer was $answer"
}



_askyesno 'y/n'
