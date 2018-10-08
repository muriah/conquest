#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX qw/ ceil /;

use experimental 'signatures';

sub log10 {
    my $n = shift;
    return ceil(log($n)/log(10));
}

sub is_palindrome($n) {
    use bignum;
    return 0 if 0 > $n;
    return 1 if 10 > $n;

    my ($is_palindrome, $r, $i) = (1, log10($n), 0);
    while ($is_palindrome && $i <= $r) {
        if ( int( ($n/(10**$i))%10 ) != int( ($n/(10**($r-$i-1)))%10 ) ) {
            $is_palindrome = 0;
        }
        $i++;
    }
    no bignum;
    return $is_palindrome;
}

sub max_palindromic_substring($s) {
    print "examining [$s]\n";
    my @string = split('', $s);
    my $palis = {};
    for (my $i = 0; $i < scalar @string; $i++) {
        if ($string[$i] eq $string[$i-1]) {
            my $l = $i - 2;
            my $r = $i + 1;
            while ($l > -1 && $r < scalar @string && $string[$l] eq $string[$r] ) {
                $l--;
                $r++;
            }
            $palis->{$i - .5} = $r - $l - 1 . '/' . join('', @string[$l+1 .. $r-1]) if $r - $l > 4;
        } else {
            my $j = 1;
            while ($i-$j > -1 && $i+$j < scalar @string && $string[$i-$j] eq $string[$i+$j] ) {
                $j++;
            }
            $palis->{$i} = 2*($j-1)+1 . '/' . join('', @string[$i-$j+1 .. $i+$j-1]) if $j > 1;
        }
    }
    return $palis;
}
#012345678901
#caabbaacfgfg
print Dumper(max_palindromic_substring('caabbaacfgfg'));
print Dumper(max_palindromic_substring('hjsabsbasjhj'));

#print 9779, ' -> ', is_palindrome(9779), "\n";
#print 97179, ' -> ', is_palindrome(97179), "\n";
#print 0, ' -> ', is_palindrome(0), "\n";
#print 1, ' -> ', is_palindrome(1), "\n";
#print 101, ' -> ', is_palindrome(101), "\n";
#print 10102, ' -> ', is_palindrome(10102), "\n";
#print 2**33, ' -> ', is_palindrome(2**33), "\n";
#print 9_007_199_229_917_009, ' -> ', is_palindrome(9_007_199_229_917_009), "\n";
#print 11_990_012_233_221_009_911, ' -> ', is_palindrome(11_990_012_233_221_009_911), "\n";
