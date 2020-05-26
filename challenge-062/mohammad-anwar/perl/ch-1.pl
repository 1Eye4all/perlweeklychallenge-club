#!/usr/bin/perl

use strict;
use warnings;

my $FILE = $ARGV[0];
my $FLAG = $ARGV[1];

my $sorted = sort_data($FILE, $FLAG);
print join "\n", @$sorted, "\n";

sub sort_data {
    my ($file, $flag) = @_;

    die "ERROR: Missing data file.\n"
        unless defined $file;

    die "ERROR: Invalid flag [$flag].\n"
        if (defined $flag && $flag !~ /^\-u$/);

    open (my $F, "<:encoding(utf8)", $file)
        or die "ERROR: Can't open $file: $!\n";

    my @source = ();
    my $source = ();
    while (my $row = <$F>) {
        chomp $row;
        my ($mailbox, $domain) = split /\@/, $row, 2;
        push @source, [$mailbox, $domain];
        if ($flag) {
            $source->{$mailbox} = lc $domain;
        }
    }

    close($F);

    my $sorted = [];
    if ($flag) {
        foreach (sort { $source->{$a} cmp $source->{$b} } sort keys %$source) {
            push @$sorted, sprintf("%s@%s", $_, $source->{$_});
        }
    }
    else {
        foreach (reverse sort { lc $a->[0] cmp lc $b->[0] || lc $a->[1] cmp $b->[1] } @source) {
            push @$sorted, sprintf("%s@%s", $_->[0], $_->[1]);
        }
    }

    return $sorted;
}