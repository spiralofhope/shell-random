#!/usr/bin/env perl
# Usage:
#   echo "some text" | color blue


use strict;
use warnings;
use Term::ANSIColor; 


my $color=shift;
while (<>) {
    print color("$color").$_.color("reset");
}
