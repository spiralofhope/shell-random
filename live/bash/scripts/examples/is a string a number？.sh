#!/usr/bin/env  bash



isnumber() {
  until [ "sky" = "falling" ]; do
    if [ ! "$#" -eq 1 ]; then echo 1 ; break ; fi
    # "nn" or "nn.nn" or "nn." or ".nn"
    if [[ "$1" =~ '^([0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^([0-9]+\.[0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^([0-9]+\.)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\.[0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\-[0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\-[0-9]+\.)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\-[0-9]+\.[0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\-\.[0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\+[0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\+[0-9]+\.)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\+[0-9]+\.[0-9]+)$' ]]; then echo 0
    elif [[ "$1" =~ '^(\+\.[0-9]+)$' ]]; then echo 0
    else
      echo 1
    fi
    break
  done
}



isnumber_test() {
  result=`isnumber "$1"`
  expecting=$2

  if [ "$expecting" = "yes" ]; then
    expecting=0
  elif [ "$expecting" = "no" ]; then
    expecting=1
  else
    printf "TEST CODE FAILED - 1"
  fi
  
  if [ $expecting -eq 1 ] && [ $result -eq 1 ]; then
    printf "pass"
  elif [ $expecting -eq 0 ] && [ $result -eq 0 ]; then
    printf "pass"
  elif [ $expecting -eq 1 ] && [ $result -eq 0 ]; then
    ((fail_count++)) ; printf "fail"
  elif [ $expecting -eq 0 ] && [ $result -eq 1 ]; then
    ((fail_count++)) ; printf "fail"
  else
    printf "TEST CODE FAILED - 2"
  fi

  echo " ($2) - $1"

}

isnumber_test_cases() {
  fail_count=0

  echo ""
  echo "Not numbers: "
  isnumber_test "a" no
  isnumber_test "abcdefghijklmnopqrstuvwxyz" no
  isnumber_test "a." no
  isnumber_test "-a" no
  isnumber_test "+a" no
  isnumber_test "a1" no
  isnumber_test "a1.0" no
  isnumber_test "++1" no
  isnumber_test "--1" no
  isnumber_test "1--" no
  isnumber_test "1++" no
  isnumber_test "..1" no
  isnumber_test "1.." no
  isnumber_test "1..0" no
  isnumber_test "1.1.1" no
  isnumber_test "-" no
  isnumber_test "+" no
  isnumber_test "." no
  isnumber_test "--" no
  isnumber_test "++" no
  isnumber_test ".." no

  echo ""
  echo "Numbers: "
  isnumber_test "11" yes
  isnumber_test "1" yes
  isnumber_test "0" yes
  isnumber_test "1." yes
  isnumber_test ".1" yes
  isnumber_test "-1" yes
  isnumber_test "+1" yes
  isnumber_test "+.1" yes
  isnumber_test "-.1" yes
  isnumber_test "1.1" yes
  isnumber_test "-1.1" yes
  isnumber_test "+1.1" yes

  if [ $fail_count = 1 ]; then
    echo $fail_count failure
  else
    echo $fail_count failures
  fi
}
