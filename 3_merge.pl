#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/ceil floor/;

use experimental 'signatures';


# $list_count
# $list_length
sub generate_lists($list_count = 2, $list_length = 10) {
    my @lists;
    for (my $i = 0; $i < $list_count; $i++) {
        my @list;
        push @list, rand(100) for (1 .. $list_length);
        push @{$lists[$i]}, sort { $a cmp $b } @list;
    }
    return \@lists;
}
# $lists[[]] - array to print
sub print_lists($lists) {
    for (0 .. scalar @$lists-1) {
        print join(', ', @{$lists->[$_]}), "\n";
        print '-'x100, "\n";
    }
}
# $lists [[],..] array of lists
sub merge_lists($lists = [[]]) {
    my @merged;

    while (scalar @{$lists->[0]} && scalar @{$lists->[1]}) {
        if ($lists->[0]->[0] lt $lists->[1]->[0]) {
           push @merged, shift @{$lists->[0]};
        } else {
           push @merged, shift @{$lists->[1]};
        }
    }

    push @merged, @{$lists->[0]}, @{$lists->[1]};

    return \@merged;
}

print "Enter `r` to generate lists || `x` to exit\n";
while (1) {
    my $input = <STDIN>;
    chomp $input;
    exit 0 if ('x' eq $input);
    do {
        my $lists = generate_lists();
        print_lists($lists);
        print_lists([merge_lists($lists)]);
        print "--\n";
        print "\n\n";
    } if ('r' eq $input);
}
