#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/ceil floor/;

use experimental 'signatures';

my $E_DEBUG = 0;
# $max_dots
# $max_x
# $max_y
sub generate_cloud ($max_dots = 20, $max_x = 20, $max_y = 20) {
    my @cloud;
    push @cloud, [int(rand($max_x)), int(rand($max_y))] foreach (0 .. $max_dots-1);
    push @cloud, [0, 0];
    return \@cloud;
}
# $cloud[[]] - array to print
sub print_cloud($cloud) {
    my $cell_w = 2; #length($sorted_y[0]->[1]) + 1;

    my @sorted_y = sort { $b->[1] <=> $a->[1] } @$cloud;
    my %cloudmap = map { $_ => [] } (0 .. $sorted_y[0]->[1]);
    my $max_x = 0;
    for (0 .. $#sorted_y) {
        push @{$cloudmap{$sorted_y[$_]->[1]}}, $sorted_y[$_]->[0];
        $max_x = $sorted_y[$_]->[0] if $sorted_y[$_]->[0] > $max_x;
    }

    my @x_axis_points = sort { $b <=> $a } keys %cloudmap;
    print "\t", join(' ', map { $_ % 10 } 0 .. $max_x), "\n";
    for my $y (@x_axis_points) {
        my @points_sorted = sort { $a <=> $b } @{$cloudmap{$y}};
        my $line = "$y\t";
        my $dcx = scalar @points_sorted;
        for (my $i = 0; $i < $dcx; $i++) {
            my $d = $i > 0 ? $points_sorted[$i] - $points_sorted[$i-1] : $points_sorted[$i];
            if ($d > 0 || $points_sorted[$i] == 0) {
                $d = $cell_w*$d;
                $d-- if ($i > 0 && $d >= $cell_w);
                $line .= sprintf('%s*', ' 'x$d);
            }
        }
        print "$line\n";
    }
    print "\t", join(' ', map { $_ % 10 } 0 .. $max_x), "\n";
    print '-' x100, "\n";
}
# $cloud [[$x,$y],..] array of dots
sub is_cloud_symmetric($cloud = [[]]) {
    my $still_sym = 1;
    my @cloud_sorted = sort { $a->[1] <=> $b->[1] || $a->[0] <=> $b->[0] } @$cloud;
    my $l = scalar @cloud_sorted;

    my ($left_idx, $right_idx, $mid) = (0, 0, undef);

    while ($still_sym && $right_idx < $l) {
        $right_idx++ while ($cloud_sorted[$right_idx] && $cloud_sorted[$left_idx]->[1] == $cloud_sorted[$right_idx]->[1]);
        $right_idx--;
        if ($mid && $mid != ($cloud_sorted[$left_idx]->[0] + ($cloud_sorted[$right_idx]->[0] - $cloud_sorted[$left_idx]->[0]) / 2)) {
            printf("!mid mismatch [%.02f] != [%.02f]\n", $mid, ($cloud_sorted[$left_idx]->[0] + ($cloud_sorted[$right_idx]->[0] - $cloud_sorted[$left_idx]->[0]) / 2)) if $E_DEBUG;
            $still_sym = 0;
            last;
        }
        $mid = ($cloud_sorted[$left_idx]->[0] + ($cloud_sorted[$right_idx]->[0] - $cloud_sorted[$left_idx]->[0]) / 2);
        printf("new mid = [%.02f]\n", $mid) if $E_DEBUG;
        my $ll = ceil(($right_idx-$left_idx)/2);
        for my $i (0 .. $ll) {
            if ($mid != ($cloud_sorted[$left_idx+$i]->[0] + ($cloud_sorted[$right_idx-$i]->[0] - $cloud_sorted[$left_idx+$i]->[0]) / 2)) {
                printf("dots mismatch [%d, %d] <-> [%d, %d]\n", $cloud_sorted[$left_idx+$i]->[0], $cloud_sorted[$left_idx+$i]->[1],
                    $cloud_sorted[$right_idx-$i]->[0], $cloud_sorted[$right_idx-$i]->[1]) if $E_DEBUG;
                $still_sym = 0;
            }
        }
        $left_idx  = $right_idx + 1;
        $right_idx = $left_idx;
    }
    printf("~axis x=[%.02f]\n", $mid) if ($still_sym);
    return $still_sym;
}

print "Enter `r` to generate cloud || `rs` to check forced sym cloud || `x` to exit || `d` to toggle debug messages\n";
while (1) {
    my $input = <STDIN>;
    chomp $input;
    exit 0 if ('x' eq $input);
    do { $E_DEBUG = !$E_DEBUG; next; } if ('d' eq $input);
    do {
        my $cloud = generate_cloud();
        print_cloud($cloud);
        print "!no axis found\n" if !is_cloud_symmetric($cloud);
        print "--\n";
        print "\n\n";
    } if ('r' eq $input);
    do {
        my $cloud = [[1, 3], [2, 3], [2, 2], [3, 1], [5, 1], [6, 2], [6, 3], [7, 3], [4, 0], [4, 20]];
        print_cloud($cloud);
        print "!no axis found\n" if !is_cloud_symmetric($cloud);
        print "--\n";
        print "\n\n";
    } if ('rs' eq $input);
}
