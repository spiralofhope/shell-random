/*
Produce a List containing the fibonacci sequence that has 1000 values in it. (See if you can do it in 4 lines)

The first two Fibonacci numbers are 0 and 1, and each remaining number is the sum of the previous two:

[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987]
*/


# Success

i=1 ; list=List(range(2))
while cast(int, list[i++ - 1]) + cast(int, list[i - 2]) < 1000:
  list.Add(cast(int, list[i - 1]) + cast(int, list[i - 2]))
print list




# Mostly-successful

i=2 ; list=List(range(2))
while i < 20:
  list.Add(cast(int, list[i - 1]) + cast(int, list[i - 2]))
  i++
print list


list=List(range(20)) ; minusone=1; minustwo=0
for i in list[2:]:
  list[i] = cast(int, list[minusone++]) + cast(int, list[minustwo++])
print list



# Previous notes

/*
list=[0,1]
source=array(int, range(0,1000))
i=0
while i > 2:
  source[i] = source[i-1] + source[i-2]
  print source[i-1] + source[i-2]

  list=list.Add( source[i-1] + source [i-2] )

list=List(range(0,1000))
for i in list[2:]:

  list[i]=(cast(int, list[i-1]))
 + (list[i-2])

  list.Add(i)

  temp=cast(int, list[i-1]) + cast(int, list[i-2])
  list.Add(temp)

 print list

print source
*/
