divide() {
  # Just simple for now.  Elsewhere I have more complex code that's more thorough
  isnumber() {
    if expr $1 + 1 &> /dev/null ; then
      \echo "0"
    else
      \echo "1"
    fi
  }

  # Since "exit" also exits xterm, I do this to allow "break" to end this procedure.
  until [ "sky" = "falling" ]; do
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] ; then \echo "Needs two parameters"; break ; fi
  # FIXME - \isnumber doesn't exist on Slackware 14.1
  #         Maybe it existed in my previous Lubuntu installation, but I haven't used this in a long time.
  if [ ! $( \isnumber $1 ) -eq 0 ] || [ ! $( \isnumber $2 ) -eq 0 ] ; then \echo "Needs two numbers"; break; fi

  left=$1
  right=$2
  answer_left=$(( $left / $right ))

  # TODO: Allow a third input to specify the number of places to give (the number of 0s)
  # TODO: Or, allow notation like divide 1 2.12345 and detect the number of places after the dot.
  #   With that, I'd have to convert the string into numbers and remove the decimal for bash to work with.  Too much math for me.  =)
  # The number of 0s is the number of places displayed after the decimal.
  left=$(( $left * 100 ))
  answer_right=$(( $left / $right ))
  # clean up $answer_left from the beginning of $answer_right
  answer_right=${answer_right#*$answer_left}

  # Add a dot.  Must be combined into a variable otherwise the final echo won't work.
  \echo $answer_left"."$answer_right

break
done
}


multiply() {
  until [ 'sky' = 'falling' ]; do
  # I should use -z and not = ''
    if [ ! "$#" -eq 2 ] || [ "$1" = '' ] || [ "$2" = '' ] ; then \echo  'Needs two parameters'; break ; fi
    if [ ! $( isnumber $1 ) -eq 0 ] || [ ! $( isnumber $2 ) -eq 0 ] ; then \echo  'Needs two numbers'; break; fi
    a=$1
    b=$2

    # remove the . from either.
    a_nodot=${a//./""}
    b_nodot=${b//./""}

    # Multiply the decimal-less numbers together:
    sum=$(( $a_nodot * $b_nodot ))

    # Learn the position of "." in each.
    a_dotloc=$( searchstring_right_r  '.'  $a )
    b_dotloc=$( searchstring_right_r  '.'  $b )

    # Add one to it, to get its position in human terms.
    # If there was no dot (-1) then make it 0.
    if [ $a_dotloc -gt '-1' ]; then ((a_dotloc--)) ; else a_dotloc=0 ; fi
    if [ $b_dotloc -gt '-1' ]; then ((b_dotloc--)) ; else b_dotloc=0 ; fi

    # add the two positions of '.' together
    dotloc=$(( $a_dotloc + $b_dotloc ))

    # insert "." into $sum
    # But first I must learn the proper insertion location.  Convert from from-right to the standard from-left.
    dotloc=$( position_from_right_to_left  $sum  $dotloc )

    # insert a '.' into $sum, but not at the end
    if [ $dotloc -ne ${#sum} ]; then sum=$( insert_character  '.'  "$sum"  $dotloc ) ; fi

    \echo $sum
  break
  done
}

