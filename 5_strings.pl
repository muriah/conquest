#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use experimental 'signatures';

# ля пары строк (e.g. “helloworld”, “hlwrd”) узнать, стоят ли символы 2й строки в том же порядке в 1й
#   (helloworld, hlwrd => true),
#   (helloworld, hwlord => false)

# $list [] array
sub is_strings_magic($str1 = '', $str2 = '') {
    my $still_matches = 1;

    my @arr1 = split('', $str1);
    my @arr2 = split('', $str2);

    my ($i, $j) = (0, 0);
    while ( $still_matches && $j < scalar @arr2 ) {
        $i++  while ( $i < scalar @arr1 && $arr2[$j] ne $arr1[$i] );
        print "- searching $arr2[$j] / i=[$i] j=[$j]\n";
        if ($i >= scalar @arr1) {
            print "!not found in 1st string: $arr2[$j]\n";
            $still_matches = 0;
        } else {
            $j++; $i++;
        }
    }
    return $still_matches;
}

print "Enter `STR1 STR2` to check strings || `x` to exit\n";
while (1) {
    my $input = <STDIN>;
    chomp $input;
    exit 0 if ('x' eq $input);

    if (my ($str1, $str2) = ($input =~ /(\w+)\s+(\w+)/ig)) {
        print is_strings_magic($str1, $str2);
        print "\n--\n";
        print "\n\n";
    }

}
