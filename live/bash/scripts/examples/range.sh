# https://web.archive.org/web/20100507001632/http://www.steve.org.uk/Reference/shell.html

function range () {
   if [ $1 -ge $2 ]; then
       return
   fi
   a=$1
   b=$2
   while [ $a -le $b ]; do
       echo $a;
       a=$(($a+1));
   done
}

for i in $(range 1 5) ;do echo $i;done
