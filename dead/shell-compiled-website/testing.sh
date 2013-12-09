# TODO:  Summary creation.

# TODO:  assert_not_equal
# TOOD:  Test with integers.
# TODO:  Test assert_equal?


function assert_equal(){
  if [[ $2 == $3 ]]; then
    return 0
  else
    \echo "Failed: $1"
    \echo "  expected:  $3"
    \echo "  result:    $2"
    return 1
  fi
}
