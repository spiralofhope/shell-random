# Logic taken from http://en.wikipedia.org/wiki/Rounding#Round-to-even_method
# "Round-to-even", aka unbiased rounding, convergent rounding, statistician's rounding, Dutch rounding, Gaussian rounding, or bankers' rounding.

# TODO: deal with "+" or "-" characters.  Should be easy.

round() {
  until [ "sky" = "falling" ]; do
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ] || [ "$1" = "" ]; then echo "Needs one or two parameters: a number and an optional position"; break ; fi

    # Check $1
    # If I've only been given a number, then what the heck am I being called upon to do?  Bail out.
    if [[ "$1" =~ '^([0-9]+)$' ]]; then echo $1 ; break ; fi
    if [[ "$1" =~ '^([0-9]+\.)$' ]]; then
      left=${1%.*}
      # FIXME: This coding cannot deal with a bad $2 ($rounding_digit_location) since that checking is done later on!!
      number=`for i in {1..${#2}}; do printf 0; done`
    # ".123" => "0.123"
    elif [[ "$1" =~ '^(\.[0-9]+)$' ]]; then
      left=0
      number=${1#*.}
    # If it's a number in the form of nnn.nnn
    elif [[ "$1" =~ '^([0-9]+\.[0-9]+)$' ]]; then
      left=${1%.*}
      number=${1#*.}
    else
      echo $1 is not a number. ; break
    fi

    # Check $2
    if [ "$2" = "" ]; then
      # By default round to this many digits
      rounding_digit_location=0
    else
      if [[ ! "$2" =~ '^([0-9]+)$' ]]; then echo $2 is not a number. ; break ; fi
      rounding_digit_location=$2
      # If the rounding digit is longer than what's available to work with, make it the maximum length.
      if [ "$rounding_digit_location" -gt ${#number} ]; then rounding_digit_location=${#number} ; fi
    fi

    # If I've been given a boring number, don't even bother to do rounding
    if [ $number = 0 ]; then
      # there a much better way to do this with some kind of {} thing, but I can't remember where I saw that note.
      until [ $rounding_digit_location -eq -1 ]; do
        final=$final"0"
        ((rounding_digit_location--))
      done
      echo $left"."$final
      break
    fi

    # Above is my error and hedge-case programming.
    # Now we begin the actual code.
    # It was translated as literally as possible from the Wikipedia English explanation.
    # Their original notes are included next to each ##

    ## Decide which is the last digit to keep.
    # Convert it to a count-from-zero

    ((rounding_digit_location--))
    item=${number:$rounding_digit_location:1}
    
    ## Increase it by 1 if the next digit is 6 or more, or a 5 followed by one or more non-zero digits.
    ## ... the next digit
    item_after=${number:$(( $rounding_digit_location + 1 )):1}
    if [ "$item_after" = "" ]; then item_after=0 ; fi
    ## ... is 6 or more
    if [ "$item_after" -ge 6 ]; then
      result=$(( $item + 1 ))
    fi
    ## ... or a 5 followed by one or more non-zero digits.
    if [ $item_after -eq 5 ]; then
      ## ... followed by one or more non-zero digits
      string_after=${number:$(( $rounding_digit_location + 2))}
      # and if I run past the edge of the string, it's 0
      if [ "$string_after" = "" ]; then string_after=0 ; fi
      if [ $string_after -gt 0 ]; then
        result=$(( $item + 1 ))
      fi
    fi
    
    ## Leave it the same if the next digit is 4 or less
    if [ $item_after -le 4 ]; then result=$item ; fi
    
    ## Otherwise, if all that follows the last digit is a 5 and possibly trailing zeroes; then increase the rounded digit if it is currently odd; else, if it is already even, leave it alone.
    if [ $item_after -eq 5 ]; then
      ## ... followed by one or more zero digits
      string_after=${number:$(( $rounding_digit_location + 2))}
      # and if I run past the edge of the string, it's 0
      if [ "$string_after" = "" ]; then string_after=0 ; fi
      if [ $string_after -eq 0 ]; then
        if [ $(( $item % 2 )) -ne 0 ]; then
          # ... then increase the rounded digit if it is currently odd
          result=$(( $item + 1 ))
        else
          # ... else, if it is already even, leave it alone.
          result=$item
        fi
      fi
    fi
    
    # take the rounded digit and slap it overtop of the original:
    final=`replace_character $result $number $rounding_digit_location`
    
    # Truncate everything past the rounded digit:
    truncate=${final:$(( $rounding_digit_location + 1 ))}
    final=${final%$truncate*}

    if [ "$left" = "" ]; then
      echo $final
    else
      if [ "$final" = "" ]; then
        # If I was given nnn.nnn but rounded to 0 digits:
        echo $left
      else
        # If I was given nnn.nnn:
        echo $left"."$final
      fi
    fi
    break
  done
}


# --------------
# Testing
# --------------
round_test() {
  result=`round $1 $2`
  expected=$3
  if [ "$result" = "$expected" ]; then printf pass ; else ((fail_count++)) ; printf fail - got $result ; fi
  echo " - $1 ($2) => $3"
}

# Cases taken from http://en.wikipedia.org/wiki/Rounding#Round-to-even_method
round_test_cases() {
  fail_count=0

  echo " Wikipedia cases"
  # 3.016 rounded to hundredths is 3.02 (because the next digit (6) is 6 or more)
  round_test 3.016 2 3.02
  # 3.013 rounded to hundredths is 3.01 (because the next digit (3) is 4 or less)
  round_test 3.013 2 3.01
  # 3.015 rounded to hundredths is 3.02 (because the next digit is 5, and the hundredths digit (1) is odd)
  round_test 3.015 2 3.02
  # 3.045 rounded to hundredths is 3.04 (because the next digit is 5, and the hundredths digit (4) is even)
  round_test 3.045 2 3.04
  # 3.04501 rounded to hundredths is 3.05 (because the next digit is 5, but it is followed by non-zero digits)
  round_test 3.04501 2 3.05

  echo " My cases"
  round_test 1 "" 1
  round_test 2 0 2
  round_test 3.00 "" 3
  round_test .44 4 0.44 # careful: this should not become 0.4400
  round_test 5.0000 1 5.0
  round_test 6.0000 2 6.00
  round_test 7. 2 7.00

  if [ $fail_count = 1 ]; then
    echo $fail_count failure
  else
    echo $fail_count failures
  fi
}
