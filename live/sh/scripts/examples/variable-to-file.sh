#!/usr/bin/env  sh


# TODO - appending


#:<<'}'
{
# dash 0.5.7-4+b1
(
cat << HERE_DOCUMENT
some text
echo this code is not executed
HERE_DOCUMENT
) >> filename.ext
}


#:<<'}'
{
# dash 0.5.7-4+b1
cat > filename.ext << HERE_DOCUMENT
some text
HERE_DOCUMENT
}
