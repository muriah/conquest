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
sub calc_chunk_averages($arr = [], $chunk_size = 1, $start_from = 1) {
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

my $array_size  = 12;
my $chunk_size  = 5;
my $start_from = 1;

my $arr = generate_array($array_size);

print "Enter `r` to generate array || `!1` to change direction || `x` to exit\n";
while (1) {
    my $input = <STDIN>;
    chomp $input;
    exit 0 if ('x' eq $input);

    if ('r' eq $input) {
        $arr = generate_array($array_size);
        print Dumper($arr);
        print Dumper(calc_chunk_averages($arr, int($chunk_size), $start_from));
        print "\n--\n";
        print "\n\n";
    }

    if ('!1' eq $input) {
        $start_from = -$start_from;
        print Dumper(calc_chunk_averages($arr, int($chunk_size), $start_from));
        print "\n--\n";
        print "\n\n";
    }

}
