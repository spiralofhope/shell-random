#!/usr/bin/perl

# I don't know if this is the original author:
# http://www.bryceharrington.org/files/btstatus

use File::Basename;
use Curses;
use strict;

sub usage {
    print "Usage:  $0 <logfile>\n";
    print "  Where logfile is in format generated by btlaunchmany\n";
    exit 0;
}

my $logfile = shift @ARGV or usage();

open DATA, "<$logfile" or die "Couldn't open $logfile: $!\n";

# Move to the end of the file, so we're looking only at new writes
seek DATA, 0, 2;

# Sort by title prefix, then season, then detail
# Highlight/color programs that have been downloaded
# Option to display errors at end of listing

sub parse_data {
    my $line = shift @_;
    my %data = ( );

    chomp $line;
    if ($line =~ m|^\#\#\# (.*)$|) {
        return undef;
    }

    if ($line =~ m|^\"(.*)\":|) {
        $data{'name'} = basename($1, ".torrent") . "\n";
        if ($data{'name'} =~ s/\.(S\d+E\d+)\./  /i) {
            $data{'detail'} = $1;
        }
    }
    if ($line =~ m|: \"(.*)\" \((.*)%\) -|) {
        $data{'time'}    = $1;
        $data{'percent'} = $2;
    }
    if ($line =~ m|- (\d+)P(\d+)S([\d\.]+)D u(.*)K/s-d(.*)K/s u(.*)K-d(.*)K|i) {
        $data{'peers'}      = $1;
        $data{'seeds'}      = $2;
        $data{'ratio'}      = $3;
        $data{'up-rate'}    = $4;
        $data{'down-rate'}  = $5;
        $data{'up-total'}   = $6;
        $data{'down-total'} = $7;
    }
    return \%data;
}

sub format_data {
    my $data = shift @_;

    if (! $data || !$data->{'name'}) {
        return undef;
    }

    return sprintf("%-30.30s  %-8.8s %-12.12s %6s %4s %4s %6s %6s %8.1f %8.1f\n",
                   $data->{'name'}||'', $data->{'detail'} || '',
                   $data->{'time'} || '', $data->{'percent'} || '',
                   $data->{'peers'} || '', $data->{'seeds'} || '',
                   $data->{'up-rate'} || '0', $data->{'down-rate'} || '0',
                   $data->{'up-total'}/1024 || '0', $data->{'down-total'}/1024 || '0',
                   );
}

my $win = new Curses;
my $heading = {
    'name' => 'Name',
    'detail' => 'Ep#',
    'time' => 'Time',
    'ratio' => 'ratio',
    'seeds' => 'S',
    'peers' => 'P',
    'percent' => '% done',
    'up-rate' => 'U K/s',
    'down-rate' => 'D K/s',
    'up-total' => 'Up M',
    'down-total' => 'Dn M'
};
my %btsession     = ();
my %btsession_new = ();
my %totals        = ();

my $y = 0;
while (1) {
    my $line = <DATA>;
    # Added to reduce CPU usage
    sleep 1 unless $line;
    next unless $line;
    if ($line eq "\n") {
        # When we see a newline, print a new record
        my @output = ();

        $win->clear;
        $win->attron(A_REVERSE);
        $win->addstr(0, 0, format_data($heading));
        $win->attroff(A_REVERSE);
        $y = 1;

        foreach my $name (sort keys %btsession) {
            my $out = format_data($btsession{$name});
            if ($btsession{$name}->{'percent'} != 100.0) {
                $win->attron(A_BOLD);
                $win->addstr($y, 0, $out);
                $win->attroff(A_BOLD);
            } else {
                $win->addstr($y, 0, $out);
            }
            $y += 1;

            $totals{'up-rate'} += $btsession{$name}->{'up-rate'};
            $totals{'down-rate'} += $btsession{$name}->{'down-rate'};
            $totals{'up-total'} += $btsession{$name}->{'up-total'};
            $totals{'down-total'} += $btsession{$name}->{'down-total'};
        }
        $win->attron(A_REVERSE);
        $win->addstr($y, 0, format_data(\%totals));
        $win->attroff(A_REVERSE);
        $win->refresh;

        # We cache the old data in case the new data misses a record or two
        %btsession     = %btsession_new;
        %btsession_new = ();
        %totals        = (
                          'name'       => 'Totals:',
                          'up-rate'    => 0.0,
                          'down-rate'  => 0.0,
                          'up-total'   => 0.0,
                          'down-total' => 0.0
                          );

    } else {
        my $data = parse_data($line);
        if ($data->{'name'} && defined $data->{'time'} && defined $data->{'up-rate'}) {
            $btsession_new{$data->{'name'}} = $data;
            $btsession{$data->{'name'}} = $data;
        }
    }
}

close DATA;