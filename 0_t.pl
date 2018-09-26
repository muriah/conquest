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
    print join(", ", @$arr), "\n\n";

    my $lambda = $$arr[$r];
    my $i = $l - 1;
    for my $j ($l .. $r - 1) {
        if ($$arr[$j] <= $lambda) {
            $i++;
            swap($arr, $i, $j);
        }
    }
    $i++;
    swap($arr, $i, $r);
    return $i;
}

sub sort_quick($arr = [], $left = 0, $right = 0) {
    if ($left >= $right) {
        return $arr;
    } else {
        my $p = i_will_eat_ur_kids_partition($arr, $left, $right);
        sort_quick($arr, $left, $p);
        sort_quick($arr, $p + 1, $right);
    }
}

my $unsorted = [1001,11,99,123,6,100,999,4,7,7,8,0,1,2,13,0,0,0];
#print i_will_eat_ur_kids_partition($unsorted, 0, $#$unsorted);
#print Dumper($unsorted);
#print Dumper(sort_bubble($unsorted));
print Dumper(sort_quick($unsorted, 0, $#$unsorted));
exit(0);

# LINKED LIST

use constant VAL => 0;
use constant NEXT => 1;

my $list = undef;
my $tail = \$list;
foreach (1..5) {
    my $node = [ $_ * $_, undef ];
    $$tail = $node; # $tail is ref to new node
    $tail = \$node->[NEXT]; # $tail is ref to new node's NEXT
}

my $listh = undef;
foreach (reverse 1..5) {
    my $node = { v => $_ * $_, n => undef };
    $node->{n} = $listh;
    $listh = $node;
}

sub add2head($list, $v) {
    my $new_node = { v => $v, n => $list };
    $list = $new_node;
    return $list;
}

sub add2tail($list, $v) {
    my $next = $list;
    return { v => $v, n => undef } unless (scalar keys %$next);
    while ($next->{n}) {
        $next = $next->{n};
    }
    $next->{n} = { v => $v, n => undef };
    return $list;
}

print Dumper(add2tail(add2tail(add2head({}, 36), 49), 0));
print Dumper(add2head(add2tail(add2tail({}, 36), 49), 0));

sub reverse_listh($listh) {
    my $r_listh;
    while (my $listh_n = $listh) {
        $listh = $listh->{n};
        $listh_n->{n} = $r_listh;
        $r_listh = $listh_n;
    }
    return $r_listh;
}

#print Dumper(reverse_listh($listh));


# $list = list_reverse( $list )
# Reverse the order of the elements of a list.
sub list_reverse {
    my $old = shift;
    my $new = undef;
    while (my $cur = $old) {
        $old = $old->[NEXT];
        $cur->[NEXT] = $new;
        $new = $cur;
    }
    return $new;
}

sub list_reverse_swapval($list) {
    my $i = 0;
    while ($i < scalar @$list / 2) {
        next if $i == scalar @$list - $i - 1;
        my $temp = $list->[$i]->[VAL];
        $list->[$i]->[VAL] = $list->[scalar @$list - $i - 1]->[VAL];
        $list->[scalar @$list - $i -1]->[VAL] = $temp;
        $i++;
    }
    return $list;
}

sub list_reverse1($list) {
    my $list_r;
    while (my $next_ref = $list) {
        $list = $list->[NEXT];
        $next_ref->[NEXT] = $list_r;
        $list_r = $next_ref;
    }
    return $list_r;
}

#print Dumper($list);
#$list = list_reverse( $list );
#print Dumper($list);
#print Dumper(list_reverse_swapval($list));
#print Dumper($list);
#print Dumper(list_reverse1($list));
