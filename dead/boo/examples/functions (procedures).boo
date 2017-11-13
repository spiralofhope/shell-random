def Hello()
  return "Hello, World!"

# It's optional, but you should define their type.  You don't want your function spitting out an object when you're expecting an int or string:

def Hello() as string:
  return "Hello, World!"

# Here's a trick.  Multiple definitions do not overwrite oneanother.  # (If you have an exact clone, it'll spit out an error though.)



# Multiple functions to handle different arguments
# (arguments = inputs)

def Hello():
    return "Hello, World!"

def Hello(name as string):   // Same name, but different parameters are allowed.
    return "Hello, ${name}!"

def Hello(num as int):
    return "Hello, Number ${num}!"

def Hello(name as string, other as string):
    return "Hello, ${name} and ${other}!"

print Hello()             # => Hello, World!
print Hello("Monkey")     # => Hello, Monkey!
print Hello(2)            # => Hello, Number 2!
print Hello("Cat", "Dog") # => Hello, Cat and Dog!



# A function that takes multiple arguments

def Test(*args as (object)):
    return args.Length

print Test("hey", "there") # => 2
print Test(1, 2, 3, 4, 5)  # => 5
print Test("test")         # => 1

# FIXME - This doesn't work, and I don't know why.
# a = (5, 8, 1)
a = ("some", "test", "thing", "ok")  # => 4
print Test(*a)
