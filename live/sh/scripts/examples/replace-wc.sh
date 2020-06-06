#!/usr/bin/env  sh


string='1234567890'


#:<<'}'   #  using wc
{
  # 10 characters
  # 11 with the carrage return
  \echo  "$string"  |  \wc --bytes
}


\echo  ${#string}
