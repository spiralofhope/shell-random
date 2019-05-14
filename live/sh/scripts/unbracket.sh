#!/usr/bin/env  sh
# Correct filenames:
# (1)    =>  001
# (11)   =>  011
# (111)  =>  111


\rename  's/\((\d)\)/00/'   \(?\)
\rename  's/\((\d\d)\)/0/'  \(??\)
\rename  's/\((\d\d\d)\)//' \(???\)
