#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use experimental 'signatures';

sub charAt($s, $i) {
    return substr($s, $i, 1);
}
sub _printm(@matrix) {
    print join(' ', @$_), "\n" for @matrix;
    print '-'x10, "\n";
}


# 885. Spiral Matrix III
sub spiralMatrixIII($R, $C, $r0, $c0) {
    my @matrix = map { my @c=(0)x$C; \@c } (1 .. $R);

    my $in_matrix = sub($r, $c) {
        return ($c < $C && -1 < $c && -1 < $r && $r < $R);
    };


    my @path;
    my $r = $r0;
    my $c = $c0;

    push @path, [$r, $c];

    my $d = 1;
    while ($R*$C > scalar @path) {
        # right
        for my $d1 (1 .. $d) {
            $c = $c + 1;
            push @path, [ $r, $c ] if &$in_matrix($r, $c);
        }
        # down
        for my $d1 (1 .. $d) {
            $r = $r + 1;
            push @path, [ $r, $c ] if &$in_matrix($r, $c);
        }
        $d++;
        # left
        for my $d1 (1 .. $d) {
            $c = $c - 1;
            push @path, [ $r, $c ] if &$in_matrix($r, $c);
        }
        # up
        for my $d1 (1 .. $d) {
            $r = $r - 1;
            push @path, [ $r, $c ] if &$in_matrix($r, $c);
        }
        $d++;
    }

    return \@path;
}


# 791. Custom Sort String
sub customSortString($S, $T) {
    my @Tarr = split('', $T);
    return join('', sort { index($S, $a) - index($S, $b) } @Tarr);
}

# 442. Find All Duplicates in an Array
sub findDuplicates($nums) {
    my $ri = scalar @$nums - 1;
    my $li = 0;
    while ($li < $ri) {
        # $nums->[$li] is not in its place
        if ( $nums->[$li] != $li + 1 ) {
            # $nums->[$li] place is busy - its a dup, leave it
            if ($nums->[$li] == $nums->[$nums->[$li]-1]) {
                $li++;
            } else {
                # $nums->[$li] place is not busy - swap it
                ($nums->[$li], $nums->[$nums->[$li]-1]) = ($nums->[$nums->[$li]-1], $nums->[$li]);
            }
        # $nums->[$li] is already in its place, leave it
        } else {
            $li++;
        }
    }
    # return numbers that are not in their place: nums[i] != i + 1
    return [(@$nums)[grep { $nums->[$_] != $_ + 1; } 0 .. $#$nums]];
}

# 877. Stone Game
sub stoneGame($piles) {
    my @alex; my $alex_sum = 0;
    my @lee;my $lee_sum = 0;
    my ($l, $r) = (0, $#$piles);
    while ($l < $r) {
        if ($piles->[$l] >= $piles->[$r]) {
            push @alex, $piles->[$l];
            $l++;
        } else {
            push @alex, $piles->[$r];
            $r--;
        }
        if ($piles->[$l] >= $piles->[$r]) {
            push @lee, $piles->[$l];
            $l++;
        } else {
            push @lee, $piles->[$r];;
            $r--;
        }
        $alex_sum += $alex[-1];
        $lee_sum += $lee[-1];
    }
    print Dumper(\@alex, \@lee);
    return $alex_sum > $lee_sum;
}

# 406. Queue Reconstruction by Height
sub reconstructQueue($people) {
    my @q;
    # sort by height, then by index
    # so index will be in all ppl that are taller (prev in sorted)
    foreach my $p ( sort { $b->[0] <=> $a->[0] || $a->[1] <=> $b->[1] } @$people ) {
        splice(@q, $p->[1], 0, $p);
    }
    return \@q;
}

# 841. Keys and Rooms
sub canVisitAllRooms($rooms) {

    my $visited = _next_room({}, $rooms, 0);
    if (scalar keys %$visited == scalar @$rooms) {
        print "can visit all rooms\n";
        return 1;
    } else {
        print "can not visit all rooms\n";
        return 0;
    }

    sub _next_room($visited, $rooms, $room) {
        return if ( exists $visited->{$room} );
        $visited->{$room} = 1;
        foreach my $key (@{$rooms->[$room]}) {
            _next_room($visited, $rooms, $key);
        }
        return $visited;
    };
}

#513. Find Bottom Left Tree Value
sub findBottomLeftValue($root) {

    my $lvl = 1;
    my $acc = { lvl => 1, v => $root->{val} };

    local *go2left = sub ($node, $lvl, $acc) {
        if ($acc->{lvl} < $lvl) {
            $acc->{lvl} = $lvl;
            $acc->{v} = $node->{val};
        }
        go2left($node->{left}, $lvl+1, $acc) if $node->{left};
        go2left($node->{right}, $lvl+1, $acc) if $node->{right};

        return $acc->{v};

    };

    return go2left($root, $lvl, $acc);

}
sub findBottomLeftValue1($root) {

    my $currentLevel = 1;
    my $firstValueOfALevel = $root->{val};

    local *traverse = sub($node, $lvl) {
        return unless $node;
        if ($currentLevel < $lvl) {
            $currentLevel = $lvl;
            $firstValueOfALevel = $node->{val};
        }
        traverse($node->{left}, $lvl + 1) if $node->{left};
        traverse($node->{right}, $lvl + 1) if $node->{right};
    };

    traverse($root, $currentLevel);

    return $firstValueOfALevel;
}

sub largestValues($root) {
    my $currentLevel = 0;
    my $maxValueOfALevel = [];

    local *traverse = sub($node, $lvl) {
        return unless $node;

        $maxValueOfALevel->[$lvl] = 0 unless $maxValueOfALevel->[$lvl];
        $maxValueOfALevel->[$lvl] = $node->{val} if $node->{val} > $maxValueOfALevel->[$lvl];

        traverse($node->{left}, $lvl + 1) if $node->{left};
        traverse($node->{right}, $lvl + 1) if $node->{right};
    };

    traverse($root, $currentLevel);

    return $maxValueOfALevel;
}

# 540. Single Element in a Sorted Array
sub singleNonDuplicate($nums) {
    my ($l, $r) = (0, $#$nums);
    my $mid = int(($r + $l) / 2);
    while ($l < $r) {
        $mid = int(($r + $l) / 2);
        my $d = $mid % 2 ? -1 : 1; # nondup can only be on even index
        # so if $mid is odd, we will compare with prev element and not next
        if ( $nums->[$mid] == $nums->[$mid + $d] ) {
            $l = $mid + 2*$d;

        } else {
            $r = $mid;
        }
    }
    return $nums->[$l];
}

#739. Daily Temperatures
sub dailyTemperatures($temperatures) {
    my $r = scalar @$temperatures - 1;
    my @w;
    for (my $i = 0; $i <= $r; $i++) {
        my $j = $i + 1;
        if ( $temperatures->[$i] > $temperatures->[$i-1] ) {
            $j = $i + $w[$i-1];
        }
        $w[$i] = $j;
        while ($r >= $j && $temperatures->[$j] < $temperatures->[$i]) {
            $j++;
        }
        if ($j == $r + 1) {
            $w[$i] = 0;
        } else {
            $w[$i] = $j - $i;
        }
    }
    return \@w;
}
#260. Single Number III
sub singleNumber($nums) {
    my %dups;
    foreach my $n (@$nums) {
        if (exists $dups{$n}) {
            delete $dups{$n} if exists $dups{$n};
        } else {
            $dups{$n} = undef;
        }
    }
    return [keys %dups];
}
sub singleNumber2($nums) {
    my $xored = 0;
    my @res;
    for (my $i = 0; $i < scalar @$nums; $i++) {
       $xored ^= $nums->[$i];
    }
    print Dumper($xored);
    print unpack('B*', $xored), "\n";
    $xored = $xored & (~ ( $xored - 1 ) );
    print Dumper($xored);
    print unpack('B*', $xored), "\n";

    for (my $i = 0; $i < scalar @$nums; $i++) {
        if (0 == ($xored & $nums->[$i])) {
            $res[0] ^= $nums->[$i];
        } else {
            $res[1] ^= $nums->[$i];
        }
    }
    return \@res;
}

# 413. Arithmetic Slices
sub numberOfArithmeticSlices($arr) {
  my %hh;
  foreach my $el ( map { $arr->[$_] - $arr->[$_-1] } (0 .. $#$arr) ) {
    $hh{$el} = exists $hh{$el} ? $hh{$el}+1 : 1;
  }
  my $arith_seq_count = 0;
  foreach my $k (keys %hh) {
    if (2 < $hh{$k}) {
      for (my $i = $hh{$k} + 1; $i > 2; $i--) {
        $arith_seq_count += ($hh{$k} + 1 - $i) + 1;
      }
    }
  }
  return $arith_seq_count;
}

# 856. Score of Parentheses
sub scoreOfParentheses2($S) {
    print $S, "\n";
    my $i = 0;
    local *rscore = sub($Sarr) {
        my $score = 0;
        while ($i < scalar @$Sarr) {
            if ('(' eq $Sarr->[$i]) {
                $i++;
                if (')' eq $Sarr->[$i]) {
                    $score += 1;
                    $i++;
                } else {
                    $score += 2 * rscore($Sarr);
                }
            } else {
                return $score;
            }
        }
        return $score;
    };
    return rscore([split('', $S)]);
}
sub scoreOfParentheses3($S) {
    print $S, "\n";
    my ($score, $layer) = (0, 0);
    for (my $i = 0; $i < length($S); ++$i) {
        print Dumper($i, $layer, $score);
        print "\n";
        $layer += ('(' eq charAt($S, $i)) ? 1 : -1;
        if ( '(' eq charAt($S, $i) && ')' eq charAt($S, $i + 1) ) {
            $score += 2**($layer - 1);
        }
    }
    return $score;
}
sub scoreOfParentheses4($S) {
    my @stack = (0);
    for (my $i = 0; $i < length($S); $i++) {
        if ( '(' eq charAt($S, $i) ) {
            push @stack, 0;
        } else {
            my $accscore = pop @stack;
            $stack[-1] += $accscore ? 2*$accscore : 1;
        }
    }
    return $stack[0];
}

# 789. Escape The Ghosts
sub escapeGhosts2($ghosts, $target) {
    my $start_point = [0, 0];
    my $my_manh_distance = abs($target->[1] - $start_point->[1]) + abs($target->[0] - $start_point->[0]);
    foreach my $ghost (@$ghosts) {
        my $ghost_manh_distance = abs($target->[1] - $ghost->[1]) + abs($target->[0] - $ghost->[0]);
        if ($ghost_manh_distance <= $my_manh_distance) {
            return 0;
        }
    }
    return 1;
}

# 609. Find Duplicate File in System
sub findDuplicate($paths) {
    my %tt;
    foreach (@$paths) {
        my ($d, @f) = split(' ', $_);
        foreach my $f_x (@f) {
            my ($fn, $fch) = ($f_x =~ /(.+)\((\w+)\)/);
            $tt{$fch} = [] unless exists $tt{$fch};
            push @{$tt{$fch}}, $d . '/' . $fn;
        }
    }
    return [ @tt{ grep { 1 < scalar @{$tt{$_}} } keys %tt } ];
}

# 451. Sort Characters By Frequency
sub frequencySort($s) {
    my @s = split('', $s);

    local *freq = sub($symbol) {
        return scalar grep { $symbol eq $_ } @s;
    };
    return join('', sort { freq($b) <=> freq($a) } @s);
}
sub frequencySort1($s) {
    my %hh;
    for (my $i = 0; $i < length($s); $i++) {
        $hh{charAt($s, $i)} = 1 + ($hh{charAt($s, $i)} || 0);
    }
    return join('', map { $_ x $hh{$_} } sort { $hh{$b} <=> $hh{$a} } keys %hh);
}
# 526. Beautiful Arrangement
sub countArrangement($N) {
    my $count = 0;
    local *calculate = sub($N, $pos, @visited) {
        if ($pos > $N) {
            $count++;
        }
        for (my $i = 1; $i <= $N; $i++) {
            if (!$visited[$i] && ($pos % $i == 0 || $i % $pos == 0)) {
                $visited[$i] = 1;
                calculate($N, $pos + 1, @visited);
                $visited[$i] = 0;
            }
        }
    };
    my @visited = (0)x($N+1);
    calculate($N, 1, @visited);
    return $count;
}
#508. Most Frequent Subtree Sum
sub findFrequentTreeSum($root) {
    my %sums;
    local *traverse = sub($node) {
        return 0 unless $node;
        my $sum = traverse($node->{left}) + $node->{val} + traverse($node->{right});
        $sums{$sum}++;
        return $sum;
    };
    traverse($root);
    my @s = sort { $sums{$b} <=> $sums{$a} } keys %sums;
    return [grep { $sums{$_} >= $sums{$s[0]} } @s];
}

#print Dumper(spiralMatrixIII(5, 6, 2, 4));
#print Dumper(customSortString('cba', 'abcdfbca'));
#print Dumper(findDuplicates([4,3,2,7,8,1,3,1]));
#print Dumper(stoneGame([4,3,2,7,8,1,3,4]));
#print Dumper(reconstructQueue( [[7,0], [4,4], [7,1], [5,0], [6,1], [5,2]] ));
#print Dumper(canVisitAllRooms( [[1,3],[3,0,1,2],[2],[0]] ));
#print Dumper(canVisitAllRooms( [[1,3],[3,0,1],[2],[0]] ));
#    1
#   / \
#  2   3
# /   / \
#4   5   7
#   /
#  6
my $happyTree = { val => 1,
    left => { val => 2,
        left => { val => 4, },
        right => undef
    },
    right => { val => 3,
        left => { val => 5, left => {val => 7}, },
        right => { val => 6, },
    }
};
#print Dumper(findBottomLeftValue($happyTree));
#print Dumper(findBottomLeftValue1($happyTree));
my $awesomeTree = { val => 1,
    left => { val => 3,
        left => { val => 5, },
        right => { val => 3, },
    },
    right => { val => 2,
        right => { val => 9, },
    }
};

# run forest run
#print Dumper(largestValues($happyTree));
#print Dumper(largestValues($awesomeTree));
#print Dumper(singleNonDuplicate([1,1,2,3,3,4,4,8,8]));
#print Dumper(singleNonDuplicate([1,1,2,2,3,3,4,4,8]));
#print Dumper(singleNonDuplicate([1,2,2,3,3,4,4,5,5,8,8]));
#print Dumper(dailyTemperatures([73, 74, 75, 71, 69, 72, 76, 73]));
#print Dumper(singleNumber([1,2,1,3,2,5]));
#print Dumper(singleNumber2([1,2,1,3,2,5]));
#print Dumper(numberOfArithmeticSlices( [1,2,3,4,5,6,8] ));
#print Dumper(scoreOfParentheses2("(()(()))"));
#print Dumper(scoreOfParentheses3("(()(()()))"));
#print Dumper(scoreOfParentheses4("(()(()()))"));
#print Dumper(escapeGhosts2([[1, 0], [0, 3]], [0, 1]));
#print Dumper(escapeGhosts2([[2, 0], [0, 3]], [1, 0]));
#print Dumper(findDuplicate( ["root/a 1.txt(abcd) 2.txt(efgh)", "root/c 3.txt(abcd)", "root/c/d 4.txt(efgh)", "root 4.txt(efgh)"] ));
#print Dumper(frequencySort('tree'), frequencySort('cccaaa'), frequencySort('Aabb'));
#print Dumper(frequencySort1('tree'), frequencySort1('cccaaa'), frequencySort1('Aabb'));
#print Dumper(countArrangement(7));
print Dumper(findFrequentTreeSum({val => 5, left => { val => 2, }, right => { val => -3, }}));
print Dumper(findFrequentTreeSum({val => 5, left => { val => 2, }, right => { val => -5, }}));
print Dumper(findFrequentTreeSum($happyTree));
