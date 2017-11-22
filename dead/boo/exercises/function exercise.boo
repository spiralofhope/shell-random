# Failed..


# Write a function that prints something nice if it is fed an even number and prints something mean if it is fed an odd number.

num=""  // has to be initialised or the below items will error.
nice="Well done, I like the number ${num}!"
mean="Bah, ${num} is terrible.  =("
other="I can't do anything with that."

def checknum():
  return other

def checknum(i as int):
  # num=num % 2
  # check if it's a number (check it's type?)
  # wrap this into a procedure..
  return nice(i), mean(i)

def getnum():
  num=prompt("Give me a number:  ")
  # sanity-checking on it.
  # If failed, repeat.
  # If success,:
  checknum(num)

print getnum()
