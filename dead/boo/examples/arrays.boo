/*
Arrays are like list, only more strict.  They are for more advanced programming for their:

# Fixed size
# Small memory footprint
# Runtime overflow checking, so you can't do a buffer overrun
# Might be either slower or faster to work with than lists.. not sure.
*/



# Each member in the array is fixed.  So you cannot initialise with 42 and replace it with "string".
a=(0,1,2,3,4)
print a[0]
# Can't do fancy stuff like a[0:]
a[0]=1
print a[0]

print "---"
b = array(range(5))
print b[4]

print "---"


list = []
for i in range(5):
    list.Add(i)
    print list[i]
# You can't do this with list:
# list[2] += 5

print "---"
# But you can absorb list into a, when a is explicitly declared as an array.
a = array(int, list)
a[2] += 5
print a[2]



# Generics

/*
Bypass the above limitation with 'list' by using cast.  Soon to be replaced in .NET 2.0 when Generics come in.  (UPDATE: I think this is wrong)

To be tested:

Generics can be used in Boo with no problem at all. Try:

  import System
  import System.Collections.Generic
  myList as List[of int] = List[of int]()

You can also use:

  booc -ducky filename.boo

, to make ducky be less strict about variable types.  It's slow, so it's only good for testing and not production.

TODO - See if `-ducky` can be combined with a verbosity level to understand which variables needed the `-ducky`.  That'll help me track down things before production.
*/


# Continued

list = List(range(5))
print '--- method one:'
for item in list:
  print cast(int, item) * 5
print '--- method two:'
for item as int in list:
  print item * item
