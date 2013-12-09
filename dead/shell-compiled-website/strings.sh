source testing.sh


function _dirname(){
  \echo ${1%/*} 
}
assert_equal \
  "_dirname" \
  $( _dirname "/foo/bar/file.ext" ) \
  "/foo/bar"


function _basename(){
  \echo ${${1##*/}%$1}
}
assert_equal \
  "_basename" \
  $( _basename "/foo/bar/file.ext" ) \
  "file.ext"
alias _filename                _basename
alias _filename_with_extension _basename


function _filename_without_extension(){
  \echo ${${${1##*/}%.*}:-${1##*/}}
}
assert_equal \
  "_filename_without_extension" \
  $( _filename_without_extension "/foo/bar/file.ext" ) \
  "file"


function _extension(){
  \echo ${1##*.}
}
assert_equal \
  "_extension" \
  $( _extension "/foo/bar/file.ext" ) \
  "ext"
