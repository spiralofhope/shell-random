#!/usr/bin/env  sh



# https://github.com/dylanaraps/pure-sh-bible
head() {
    # Usage: head "n" "file"
    while IFS= read -r line; do
        printf '%s\n' "$line"
        i=$(( i + 1 ))
        [ "$i" = "$1" ] && return
    done < "$2"

    # 'read' used in a loop will skip over
    # the last line of a file if it does not contain
    # a newline and instead contains EOF.
    #
    # The final line iteration is skipped as 'read'
    # exits with '1' when it hits EOF. 'read' however,
    # still populates the variable.
    #
    # This ensures that the final line is always printed
    # if applicable.
    [ -n "$line" ] && printf %s "$line"
}

# head 2 ~/.bashrc
