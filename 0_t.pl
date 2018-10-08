#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use experimental 'signatures';

# bubble sort
# quick sort
# разворот 1, 2-связного списка
# разворот строки
# perl -e 'my$str="dfaadfadgadbagqaeen"; print reverse split("",$str);'
# perl -e 'my$str="dfaadfadgadbagqaeen"; print substr($str, length($str) - $_, 1) for (1 .. length($str));'
# perl -e 'my$str="asdfghjkl"; print reverse ($str =~ /\w{1}/ig)'
# обход дерева

# BUBBLE SORT

sub swap($arr, $i, $j) {
    @$arr[$i, $j] = @$arr[$j, $i];
}

sub sort_bubble($arr = []) {
    while (1) {
        my $swap_count = 0;
        for (my $i = 0; $i < $#$arr; $i++) {
            if ($$arr[$i] > $$arr[$i+1]) {
                swap($arr, $i, $i+1);
                $swap_count++;
            }
        }
        if (0 == $swap_count) {
            last;
        }
    }
    return $arr;
}

# i mean it
sub i_will_eat_ur_kids_partition($arr, $l, $r) {
    #print join(", ", @$arr), "\n\n";

    my @t = splice(@$arr, $l, $r+1);
    #print '->', join(',', @$arr), "\n";
    #print join(',', @t), "\n";
    my $pivot = $t[0];
    my $pivot_idx = 0;
    my $i = 1;
    while ($i <= $#t) {
        #print "!i1 = $i / $pivot_idx\n";
        #print $t[$i], " <=> ", $pivot, "\n";
        if ($t[$i] < $pivot) {
            if ($i > $pivot_idx) {
                unshift @t, splice(@t, $i, 1);
                $i = ++$pivot_idx;
            }
        } elsif ($t[$i] > $pivot) {
            if ($i < $pivot_idx) {
                push @t, splice(@t, $i, 1);
                $i = --$pivot_idx;
            }
        }
        $i++;
        #print join(", ", @t), "\n\n";
    }

    splice(@$arr, $l, 0, @t);
    #print '-->', join(',', @$arr), "\n\n";
    return $l + $pivot_idx;
}

sub partition($arr, $l, $r) {
    my $pivot = $$arr[$l];
    my $pivot_idx = $l; # idx of the last element < pivot, we will swap it with pivot at the end
    for my $j ( $l + 1 .. $r ) {
        if ($pivot >= $$arr[$j]) {
            $pivot_idx++;
            swap($arr, $pivot_idx, $j);
        }
    }
    swap($arr, $pivot_idx, $l);
    return $pivot_idx;
}

sub _sort_quick($arr = [], $left = 0, $right = 0) {
    if ($left >= $right) {
        return $arr;
    } else {
        my $p = partition($arr, $left, $right);
        _sort_quick($arr, $left, $p - 1);
        _sort_quick($arr, $p + 1, $right);
    }
}

sub sort_quick($arr = []) {
    return $arr if (2 > @$arr);
    return _sort_quick($arr, 0, $#$arr);
}

sub sort_quick_grep(@arr) {
    return @arr if 1 >= @arr;
    my $pivot = shift @arr;
    sort_quick_grep( grep { $_ < $pivot } @arr ), $pivot, sort_quick_grep( grep { $_ >= $pivot } @arr );
}

#my $unsorted = [1001,11,99,123,6,100,999,4,7,7,8,0,1,2,13,0,0,0];
#print Dumper(sort_bubble($unsorted));
#$unsorted = [76,79,99,123,6,100,999,4,7,7,8,0,1,2,13,0,0,78];
#print Dumper(sort_quick($unsorted));
print Dumper(sort_quick_grep((76,79,99,123,6,100,999,4,7,7,8,0,1,2,13,0,0,78)));
exit(0);


__DATA__
sub partition($arr, $l, $r) {
    print join(", ", @$arr[$l .. $r]), "\n";

    my $lambda = $$arr[$r];
    my $i = $l - 1;
    for my $j ($l .. $r - 1) {
        if ($lambda >= $$arr[$j]) {
            $i++;
            swap($arr, $i, $j);
        }
        print '- ', join(", ", @$arr[$l .. $r]), "\n";
    }
    swap($arr, $i+1, $r);
    print join(", ", @$arr[$l .. $r]), "\n";
    print "---\n";
    return $i+1;
}
