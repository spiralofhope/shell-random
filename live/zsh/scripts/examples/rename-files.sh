#!/usr/bin/env  zsh



a=sometext

for i in {01..20}; do
  if [ -d ${i}*(-/) ]; then
    \cd  ${i}*(-/)
    \rename  ${a}${i}_  ""  *.jpg
    \cd  -
  else
    :
  fi
done

# a=sometext ; for i in {01..20}; do if [ -d ${i}*(-/) ]; then cd ${i}*(-/) ; rename ${a}${i}_ "" *.jpg ; cd - ; else ; fi ; done
