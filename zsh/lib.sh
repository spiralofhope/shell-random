# Used by other functions.
# Loaded first, before everything.

# TODO - Fucking hell, `du` has trailing spaces and the name of the directory.  It even puts '.' if nothing is specified.
# TODO - remove a trailing period.
# TODO - remove trailing spaces.
comma() {
  if [ -z $1 ]; then
    # Incorrect usage.
  elif [ -z $2 ]; then
    \echo "$1" | \sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta'
  else
    # Incorrect usage.
  fi
}
# Although at the commandline, this works:
#   comma 1000
# This is the required way to use it when scripting:
#   comma '1000'
# Or more complex:
#   local count=$( comma $( \ls -1 . | \wc -l ) )


# http://www.codecodex.com/wiki/Shuffle_an_array#Zsh
#function shuffle_array {
	#RANDOM=$$ 
	
	#local array shuffled size count index
	#integer size count index
	#typeset -a array shuffled

	#array=(${=*}) # Limited to 32767 elements because $RANDOM.
	#size=${(w)#array}
	
	#while ((count++ < size))
	#do
		#index=$((1 + (${(w)#array} * RANDOM / 32767)))
		#shuffled+=($array[$index])
		#array[$index]=()
	#done
#}


# http://www.codecodex.com/wiki/Shuffle_an_array#Zsh
#function fisher-yates_shuffle_array {
	#zmodload zsh/mathfunc

	#typeset -a array swap
	#integer n k
	
	#array=(${=*}) 
	#n=${(w)#array} 

	#for ((n += 1 ; n > 0 ; n--))
	#do
		#((k = 1 + int(rand48() * n)))
		#swap=($array[k])
		#array[k]=$array[n]
		#array[n]=$swap
	#done
#}
