# This stuff was in zsh's lib.sh, but it was all commented-out.


# http://www.codecodex.com/wiki/Shuffle_an_array#Zsh
function shuffle_array {
	RANDOM=$$ 
	
	local array shuffled size count index
	integer size count index
	typeset -a array shuffled

	array=(${=*}) # Limited to 32767 elements because $RANDOM.
	size=${(w)#array}
	
	while ((count++ < size))
	do
		index=$((1 + (${(w)#array} * RANDOM / 32767)))
		shuffled+=($array[$index])
		array[$index]=()
	done
}


# http://www.codecodex.com/wiki/Shuffle_an_array#Zsh
function fisher-yates_shuffle_array {
	zmodload zsh/mathfunc

	typeset -a array swap
	integer n k
	
	array=(${=*}) 
	n=${(w)#array} 

	for ((n += 1 ; n > 0 ; n--))
	do
		((k = 1 + int(rand48() * n)))
		swap=($array[k])
		array[k]=$array[n]
		array[n]=$swap
	done
}
