# TODO - edit this so that I can ./unpercent filename.ext

# This can be used like:
# for i in *; do cd "$i"; unpercent "$i"/* ; cd - ; done

unpercent() {
  search=%${1}
  replace=\\${2}
  \rename --verbose "s/${search}/${replace}/i" *
}

# https://en.wikipedia.org/wiki/Percent-encoding

# Percent-encoding reserved characters
unpercent 21 \!
unpercent 23 \#
unpercent 24 \$
unpercent 26 \&
unpercent 27 \'
unpercent 28 \(
unpercent 29 \)
unpercent 2A \*
unpercent 2B \+
unpercent 2C \,
unpercent 2F \/
unpercent 3A \:
unpercent 3B \;
unpercent 3D \=
unpercent 3F \?
unpercent 40 \@
unpercent 5B \[
unpercent 5D \]

# Character data

unpercent 20 \   # space
unpercent 22 \"
unpercent 25 \%
unpercent 2D \-
unpercent 2E \.
unpercent 3C \<
unpercent 3E \>
unpercent 5C \\
unpercent 5E \^
unpercent 5F \_
unpercent 60 \`
unpercent 7B \{
unpercent 7C \|
unpercent 7D \}
unpercent 7E \~

