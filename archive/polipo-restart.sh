# write out all the in-memory data to disk
# discard as much of the memory cache as possible
# reopen the log file
# reload the forbidden URLs file

kill -s SIGUSR2 `cat "/tmp/polipo.pid"`
