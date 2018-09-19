#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/ceil floor/;

use experimental 'signatures';

my $E_DEBUG = 0;
my $CX_REC_SAFENET = 1000;
my ($W, $H) = (15, 15);

# $str - string to examine
sub is_look_like_number($str = '') {
    return 1 if '0' eq $str;
    return $str && !($str =~ /\D/ig);
}
# $m - width
# $n - height
sub generate_matrix ($m = 10, $n = 10) {
    my $r = int(rand()*17) + 1;
    my @matrix;
    foreach (0 .. $m-1) {
        for (my $j = 0; $j < $n; $j++) {
            $matrix[$_][$j] = ($_ + 2*$j) * $r + 1;
        }
    }
    return \@matrix;
}

# $matrix - matrix to print
sub print_matrix($matrix) {
    my ($w, $h) = (scalar @{$matrix->[0]}, scalar @$matrix);
    print "\t", join("\t", (0..$w-1)), "\n";
    print '-'x100, "\n";
    for (my $idx = 0; $idx < $h; $idx++) {
        print "$idx |\t";
        print join("\t", @{$matrix->[$idx]}), "\n";
    }
}

# $matrix - matrix to search in
# $number - number to search
sub is_number_in_matrix_stepwise($matrix = [[]], $number = -1) {
    return 0 if ( $number > $matrix->[-1]->[-1] );
    return 0 if ( $number < $matrix->[0]->[0] );

    my ($m, $n) = (scalar @$matrix - 1, 0);

    my $width = scalar @{$matrix->[0]};
    my $searching = 1;
    while ($searching) {
        $searching = 0 if (0 >= $m || $n >= $width);
        if ($number == $matrix->[$m]->[$n]) {
            printf("~found at matrix->[%d]->[%d]\n", $m, $n);
            return 1;
        } else {
            printf("matrix[%d][%d] = %d\n", $m, $n, $matrix->[$m]->[$n]) if $E_DEBUG;
        }
        if ( $number > $matrix->[$m]->[$n] ) {
            $n++;
        } else {
            $m--;
        }
    }
    return 0;
}
# $matrix - matrix to search in
# $number - number to search
# $left, $right, $top, $bottom - indices of submatrix in main matrix
sub is_number_in_matrix_quad_partition($matrix = [[]], $number = -1, $left = 0, $right = 0, $top = 0, $bottom = 0) {
    printf("l[%d] r[%d] t[%d] b[%d]\n", $left, $right, $top, $bottom) if $E_DEBUG;
    die('I suck at recursion, sry') if 0 > $CX_REC_SAFENET--;

    return 0 if ( $left > $right || $top > $bottom );
    return 0 if ( $number > $matrix->[$bottom]->[$right] );
    return 0 if ( $number < $matrix->[$top]->[$left] );

    my $mcol = $left + floor(($right - $left) / 2);
    my $mrow = $top + floor(($bottom - $top) / 2);

    printf("row[%s] + col[%s]\n", $mrow, $mcol) if $E_DEBUG;

    if ($matrix->[$mrow]->[$mcol] == $number) {
        printf("~found at matrix->[%d]->[%d]\n", $mrow, $mcol);
        return 1;
    } elsif ($left == $right && $top == $bottom) {
        return 0;
    }

    if ($number < $matrix->[$mrow]->[$mcol]) {
        printf("m[%d] > n[%d]\n", $matrix->[$mrow]->[$mcol], $number) if $E_DEBUG;
        return is_number_in_matrix_quad_partition($matrix, $number, $mcol+1, $right, $top, $mrow) ||
            is_number_in_matrix_quad_partition($matrix, $number, $left, $mcol, $mrow+1, $bottom) ||
            is_number_in_matrix_quad_partition($matrix, $number, $left, $mcol, $top, $mrow);
    } else {
        printf("m[%d] < n[%d]\n", $matrix->[$mrow]->[$mcol], $number) if $E_DEBUG;
        return is_number_in_matrix_quad_partition($matrix, $number, $mcol+1, $right, $top, $mrow) ||
            is_number_in_matrix_quad_partition($matrix, $number, $left, $mcol, $mrow+1, $bottom) ||
            is_number_in_matrix_quad_partition($matrix, $number, $mcol+1, $right, $mrow+1, $bottom);
    }
}

# $matrix - matrix to search in
# $number - number to search
# $left, $right, $top, $bottom - indices of submatrix in main matrix
sub is_number_in_matrix_binary_partition($matrix = [[]], $number = -1, $left = 0, $right = 0, $top = 0, $bottom = 0) {
    die('I suck at recursion, sry') if 0 > $CX_REC_SAFENET--;
    return 0 if ( $left > $right || $top > $bottom );
    return 0 if ( $number > $matrix->[$bottom]->[$right] );
    return 0 if ( $number < $matrix->[$top]->[$left] );

    my $mrow = $top + floor(($bottom - $top) / 2);
    my $mcol = $left;
    while ($mcol < $right && $number > $matrix->[$mrow]->[$mcol]) {
        $mcol++;
    }

    if ($matrix->[$mrow]->[$mcol] == $number) {
        printf("~found at matrix->[%d]->[%d]\n", $mrow, $mcol);
        return 1;
    } elsif ($left == $right && $top == $bottom) {
        return 0;
    } else {
        return is_number_in_matrix_binary_partition($matrix, $number, $mcol+1, $right, $top, $mrow-1) ||
            is_number_in_matrix_binary_partition($matrix, $number, $mrow+1, $bottom, $left, $mcol);
    }
}

my $mx = generate_matrix($W, $H);
print_matrix($mx);
print '-' x10, "\n";

print "Enter a number find || `x` to exit || `d` to toggle debug messages\n";
while (1) {
    my $input = <STDIN>;
    chomp $input;
    exit 0 if ('x' eq $input);
    do { $E_DEBUG = !$E_DEBUG; next; } if ('d' eq $input);

    if (is_look_like_number($input)) {
        print "stepwise:\n";
        print "!not_found\n" if !is_number_in_matrix_stepwise($mx, $input);
        print "\nquadpartition:\n";
        print "!not_found\n" if !is_number_in_matrix_quad_partition($mx, $input, 0, $W-1, 0, $H-1);
        print "\nbinarypartition:\n";
        print "!not_found\n" if !is_number_in_matrix_binary_partition($mx, $input, 0, $W-1, 0, $H-1);
        print "--\n";
        print "\n\n";
    } else {
        print "doesnt look like a number, try again\n";
    }
}
