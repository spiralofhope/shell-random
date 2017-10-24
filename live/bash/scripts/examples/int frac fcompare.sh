#!/usr/bin/env  bash



# http://groups.google.com/group/comp.os.linux.misc/browse_frm/thread/e97de27b3e32643f?hl=en&lr=&ie=UTF-8&rnum=1&prev=/groups%3Fhl%3Den%26lr%3D%26ie%3DISO-8859-1%26q%3D%2BCompare%2Bdecimal%2Bnumbers%2Bin%2Ba%2Bshell%2Bscript%26btnG%3DGoogle%2BSearch%26meta%3Dgroup%253Dcomp.os.linux.misc

:<<'NOTES'
   int - return the integer portion of a decimal number
         return 0 if there is no integer portion

   frac - return the decimal portion of a decimal number
          return 0 if there is no decimal portion

   fpcompare - if the first argument is greater than the second, return 1
               if the first argument is less than the second, return -1
               if the two arguments are equal, return 0

   The result of each function is placed in a variable whose name is
   the name of the function converted to upper case and preceded by an
   underscore (e.g., int stores its result in _INT).

   The result is echoed if _SILENT_FUNCS is not set to 1.
NOTES




### the functions:
int() {
  _INT=0
  case $1 in
    .*|"") _INT=0 ;;
    *.*) _INT=${1%.*} ;;
    *) _INT=$1 ;;
  esac
  [ "$_SILENT_FUNCS" = 1 ] || echo ${_INT}
}



dec() {
  _DEC=0
  case $1 in
    .*) _DEC=${1#?} ;;
    *.) _DEC=0 ;;
    *.*) _DEC=${1#*.} ;;
  esac
  [ "$_SILENT_FUNCS" = 1 ] || echo ${_DEC}

}



fpcompare() {
  [ $# = 2 ] || { _FPCOMPARE=5; return 5; }
  neg1=
  neg2=
  case $1 in -*) neg1=-; num1=${1#-} ;; esac
  case $2 in -*) neg2=-; num2=${2#-} ;; esac
  _FPCOMPARE=0
  _SILENT_FUNCS=1 int $num1
  int1=$_INT
  _SILENT_FUNCS=1 int $num2
  int2=$_INT
  if [ "$neg1$int1" -gt "$neg2$int2" ]
  then
    _FPCOMPARE=1
  elif [ "$neg1$int1" -lt "$neg2$int2" ]
  then
    _FPCOMPARE=-1
  else
    _SILENT_FUNCS=1 dec $1
    dec1=$_DEC
    _SILENT_FUNCS=1 dec $2
    dec2=$_DEC
    while [ ${#dec1} -ne ${#dec2} ]
    do
      [ ${#dec1} -gt ${#dec2} ] && dec2=${dec2}0
      [ ${#dec2} -gt ${#dec1} ] && dec1=${dec1}0
    done
    if [ "$neg1$dec1" -gt "$neg2$dec2" ]
    then
        _FPCOMPARE=1
    elif [ "$neg1$dec1" -lt "$neg2$dec2" ]
    then
        _FPCOMPARE=-1
    fi
  fi
  [ "$_SILENT_FUNCS" = 1 ] || echo ${_FPCOMPARE}
}
