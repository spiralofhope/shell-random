#!/usr/bin/env  zsh



string="This is a string"


# Fetch the first few words:
echo ${${string}[0,1]}                                                  #  => This
echo ${${string}[0,2]}                                                  #  => This is

# Fetch the last few words:
echo ${${string}[-1,-1]}                                                #  => string
echo ${${string}[-2,-1]}                                                #  => a string

# Fetch the first few characters:
echo ${"${string}"[0,1]}                                                #  => T
echo ${"${string}"[0,2]}                                                #  => Th

# Fetch the last few characters:
echo ${"${string}"[-1,-1]}                                              #  => g
echo ${"${string}"[-2,-1]}                                              #  => ng
