# https://github.com/boo-lang/boo/wiki/Boo-Primer:-%5BPart-04%5D-Flow-Control-And-Loops

# 1. print out all the numbers from 10 to 1.

# Simple:

i=10
while i>0:
  print i
  i--



# In a row:

i=10
a=""
while i>0:
  a=a + i + " "
  i--
print a



# 2. print out all the squares from 1 to 100.

i=100
while i>0:
  print i + " - " + i*i
  i--
