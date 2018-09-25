#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use experimental 'signatures';

# Дан массив целых чисел, задано число N, определяющее размер "окна" в этом массиве.
# Написать реализацию класса, позволяющую пройтись по заданному массиву в одном направлении и на каждом шаге возвращающую среднее значение N текущих элементов

# $size array size
sub generate_array($size = 0) {
    my @a;
    $size = 100 if ($size > 100);
    for (0 .. $size-1) {
       push @a, rand(1000);
    }
    return \@a;
}

# $arr [] array
sub calc_chunk_avg_step_chunk($arr = [], $chunk_size = 1, $start_from = 1) {
    my @aarr;

    my $i = -1 == $start_from ? 1 : 0;
    my $arr_length = scalar @$arr;
    my $max_chunks = int($arr_length / $chunk_size) + 1;
    my $mod        = $arr_length % $chunk_size;
    while ($i <= $max_chunks) {

        my $left = $start_from*$i*$chunk_size;
        $left = -$arr_length if $left < -$arr_length-1;
        my $right = -1 + $start_from*($i+$start_from)*$chunk_size;
        $right = $arr_length-1 if $right > $arr_length-1;

        last if $left > $right;
        my $ch = $right - $left + 1;

        push @aarr, { chunk => sprintf('[%d, %d]', $left, $right), avg => 0 };

        for ( $left .. $right ) {
            $aarr[-1]->{avg} += $arr->[$_] / $ch;
        }

        $i++;
    }

    return \@aarr;
}

sub calc_chunk_avg_step_one($arr = [], $chunk_size = 1, $start_from = 1) {
    my @aarr;

    #for my $i (0 .. scalar @$arr-1) {
    #    my $right = $i + $chunk_size - 1;
    #    $right = scalar @$arr-1 if $right > scalar @$arr-1;
    #    my $ch = $right - $i + 1;
    #    push @aarr, { chunk => sprintf('[%d, %d]', $i, $right), avg => 0 };
    #    for (my $j = $i; $j <= $right; $j++) {
    #        $aarr[-1]->{avg} += $arr->[$j] / $ch;
    #    }
    #}

    my $arr_length = scalar @$arr;
    my $i = 0;
    while ($i <= $arr_length) {

        my $left = (-1 == $start_from) ? -($i+$chunk_size) : $i;
        my $right = $left + $chunk_size - 1;
        $right = $arr_length-1 if $right > $arr_length-1;

        # actual element count to find avg if we have less than $chunk_size left
        my $ch = $right - $left + 1;

        if ($left < -$arr_length) {
            $left  = -$arr_length;
            $ch    = $right - $left + 1;
            $right = $left + $ch - 1;
        }

        last if $left > $right;

        push @aarr, { chunk => sprintf('[%d, %d]', $left, $right), avg => 0 };
        for ( $left .. $right ) {
            $aarr[-1]->{avg} += $arr->[$_] / $ch;
        }

        $i++;

    }

    return \@aarr;
}

my $array_size = 12;
my $chunk_size = 5;
my $start_from = 1;

my $arr = [];

print "Enter `r` to calc w/step=chunk || `!r` to change direction || `r1` to calc w/step=1 || `!r1` to change direction || `x` to exit\n";
while (1) {
    my $input = <STDIN>;
    chomp $input;
    exit 0 if ('x' eq $input);

    if ('r' eq $input) {
        $arr = generate_array($array_size);
        print Dumper($arr);
        print Dumper(calc_chunk_avg_step_chunk($arr, int($chunk_size), $start_from));
        print "\n--\n";
        print "\n\n";
    } elsif ('!r' eq $input) {
        $start_from = -$start_from;
        print Dumper(calc_chunk_avg_step_chunk($arr, int($chunk_size), $start_from));
        print "\n--\n";
        print "\n\n";
    } elsif ('r1' eq $input) {
        $arr = generate_array($array_size);
        print Dumper($arr);
        print Dumper(calc_chunk_avg_step_one($arr, int($chunk_size), $start_from));
        print "\n--\n";
        print "\n\n";
    } elsif ('!r1' eq $input) {
        $start_from = -$start_from;
        print Dumper(calc_chunk_avg_step_one($arr, int($chunk_size), $start_from));
        print "\n--\n";
        print "\n\n";
    }
}
