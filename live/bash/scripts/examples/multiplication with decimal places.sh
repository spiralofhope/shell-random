:<<NOTES
Requirements:

* searching through a string for a character.sh
  **  > Counting from the right
  **  > giving position from the right
* convert position from right to left.sh
* string edit - insert a character.sh



multiply 1.2 1.2
=> 1.44

a=`multiply 1.2 1.2`;echo $a
=> 1.44

multiply 12.34 56.78
=> 700.6652

multiply 10 12
=> 120

multiply 10.0 12
=> 120.0

multiply 10.0 12.0
=> 120.00
NOTES



multiply() {
  until [ "sky" = "falling" ]; do
    if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] ; then echo "Needs two parameters"; break ; fi
    if [ ! `isnumber $1` -eq 0 ] || [ ! `isnumber $2` -eq 0 ] ; then echo "Needs two numbers"; break; fi

    a=$1
    b=$2

    # remove the . from either.
    a_nodot=${a//./""}
    b_nodot=${b//./""}

    # Multiply the decimal-less numbers together:
    sum=$(( $a_nodot * $b_nodot ))

    # Learn the position of "." in each.
    a_dotloc=`searchstring_right_r "." $a`
    b_dotloc=`searchstring_right_r "." $b`

    # Add one to it, to get its position in human terms.
    # If there was no dot (-1) then make it 0.
    if [ $a_dotloc -gt "-1" ]; then ((a_dotloc--)) ; else a_dotloc=0 ; fi
    if [ $b_dotloc -gt "-1" ]; then ((b_dotloc--)) ; else b_dotloc=0 ; fi

    # add the two positions of "." together
    dotloc=$(( $a_dotloc + $b_dotloc ))

    # insert "." into $sum
    # But first I must learn the proper insertion location.  Convert from from-right to the standard from-left.
    dotloc=`position_from_right_to_left $sum $dotloc`

    # insert a "." into $sum, but not at the end
    if [ $dotloc -ne ${#sum} ]; then sum=`insert_character "." "$sum" $dotloc` ; fi

    echo $sum
  break
  done
}
