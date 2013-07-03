wget -nc -c --limit-rate=5k --random-wait -x --convert-links --mirror --page-requisites --no-parent %1
# --recursive --level=5
#
#        --ignore-length
#           Unfortunately, some HTTP servers (CGI programs, to be more precise) send out bogus "Content-Length"
#           headers, which makes Wget go wild, as it thinks not all the document was retrieved.  You can spot this
#           syndrome if Wget retries getting the same document again and again, each time claiming that the (other-
#           wise normal) connection has closed on the very same byte.
#
#           With this option, Wget will ignore the "Content-Length" header---as if it never existed.
#

