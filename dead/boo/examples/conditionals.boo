# if/then/else

i = 5
if i > 5:
  print "i is greater than 5."
elif i == 5:
  print "i is equal to 5."
elif i < 5:
  print "i is less than 5."
else:
  print "impossible"



# unless

i = 5
unless i == 5:
  print "i is equal to 5."

i = 0
print i
i = 5 if true
print i
i = 10 unless true
print i



# not

i = 0
if not i > 5:
  print 'i is not greater than 5'



# if, with, and, or

i = 5
if i > 0 and i < 10:
  print "i is between 0 and 10."
if i < 3 or i > 7:
  print "i is not between 3 and 7."
if (i > 0 and i < 3) or (i > 7 and i < 10):
  print "i is either between 0 and 3 or between 7 and 10."
