# https://github.com/boo-lang/boo/wiki/Boo-Primer:-%5BPart-03%5D-Flow-Control-And-Conditionals



# Given the numbers x = 4, y = 8, and z = 6, compare them and print the middle one.

x = 4
y = 8
z = 6

midnum=x
midvar="x"
if x < y:
  midnum=y
  midvar="y"
if y > z:
  midnum=z
  midvar="z"

print "I was given: x=${x}, y=${y}, z=${z}"
print "The middle variable is: ${midvar}=${midnum}"
