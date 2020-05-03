#!/usr/bin/env  bash



:<<'}'   #  Ancient notes
{
ARRAY=( .jpg .gif .png )
for element in ${ARRAY[@]} ; do
  echo $element
  # other stuff on $element
done
}
