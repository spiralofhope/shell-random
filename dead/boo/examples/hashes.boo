# Like a list, but a hash can contain anything

hash = {'a': 1, 'b': 2, 'monkey': 3, 42: 'the answer'}
print hash['a'] # => 1
print hash[42]  # => the answer

print '---'
for item in hash:
  print item.Key, '=>', item.Value

# the same hash can be created from a list like this :
ll = [ ('a',1), ('b',2), ('monkey',3), (42, "the answer") ]
hash = Hash(ll)
