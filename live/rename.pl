#!/usr/bin/perl -w
# rename.pl
#
#  Discussion:
#
#    rename.pl 'tr/A-Z/a-z/' *
#
#    will rename every file so that its name is lowercase.
#
#    rename.pl 's/\.orig$//' *.orig
#
#    will, for every file that ends in ".orig", rename the
#    file by removing the trailing ".orig".
#
#    rename.pl '$_ .= ".old"' *.cc
#
#    will append ".old" to the name of every file that ends in ".cc".
#
#  Modified:
#
#    20 March 2004
#
#  Author:
#
#    Larry Wall
#
#  Reference:
#
#    Tom Christiansen and Nathan Torkington,
#    The Perl Coookbook,
#    Chapter 9.9, Renaming Files
#    O'Reilly, 1999
#
$op = shift or die "Usage: rename expr [files]\n";
chomp(@ARGV = <STDIN>) unless @ARGV;
for ( @ARGV )
{
  $was = $_;
  eval $op;
  die $@ if $@;
  rename ( $was, $_ ) unless $was eq $_;
}
