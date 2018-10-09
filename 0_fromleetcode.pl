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
# 508. Most Frequent Subtree Sum
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
# 748. Shortest Completing Word
sub shortestCompletingWord($licensePlate, $words) {
    my $alrdy_found;

    my @lp_symbols = grep { $_ =~ /[a-zA-Z]/g } split('', lc($licensePlate));

    foreach my $word (@$words) {

        next if ($alrdy_found && length($word) > length($alrdy_found));

        my $mb_found = $word;
        foreach my $symbol (@lp_symbols) {
            if (-1 < index($mb_found, $symbol)) {
                $mb_found =~ s/$symbol/_/;
            } else {
                $mb_found = undef;
                last;
            }
        }
        if ( $mb_found && (!$alrdy_found || (length($alrdy_found) > length($word))) ) {
            $alrdy_found = $word;
        }
    }
    return $alrdy_found;
}

# 712. Minimum ASCII Delete Sum for Two Strings
sub minimumDeleteSum($s1, $s2) {
    my ($s1le, $s2le) = (length($s1), length($s2));
    my @dp;
    push @dp, [(0) x ($s2le+1)] for (0 .. $s1le);
    for (my $i = 1; $i <= $s1le; $i++) {
        for (my $j = 1; $j <= $s2le; $j++) {
            if (charAt($s1, $i-1) eq charAt($s2, $j-1)) {
                $dp[$i]->[$j] = $dp[$i-1]->[$j-1] + ord(charAt($s1, $i-1)) + ord(charAt($s2, $j-1));
            } else {
                $dp[$i]->[$j] = $dp[$i-1]->[$j] > $dp[$i]->[$j-1] ?
                    $dp[$i-1]->[$j] :
                    $dp[$i]->[$j-1];
            }
        }
    }
    _printm(@dp);
    my $s1sum = 0; $s1sum += ord(charAt($s1, $_-1)) for (1 .. $s1le);
    my $s2sum = 0; $s2sum += ord(charAt($s2, $_-1)) for (1 .. $s2le);
    return $s1sum + $s2sum - $dp[-1]->[-1];

}
# 865. Smallest Subtree with all the Deepest Nodes
sub subtreeWithAllDeepest($root) {
    my @nodes = ($root->{val});
    my @stack = ($root);
    while (scalar @stack) {
        my $node = shift @stack;
        push @stack, $node->{left} if $node->{left};
        push @stack, $node->{right} if $node->{right};
        push @nodes, exists $node->{left} ? $node->{left}->{val} : undef,
            exists $node->{right} ? $node->{right}->{val} : undef;
    }
    # find deepest child
    my $r = -1;
    $r-- while (!$nodes[$r]);
    # find parent index
    my $idx = int(($#nodes + $r)/2) == ($#nodes + $r)/2 ? ($#nodes + $r)/2 :
        ($#nodes + $r - 1)/2;
    return [@nodes[$idx, 2*$idx+1, 2*$idx+2]];
}

# 238. Product of Array Except Self
sub productExceptSelf2($nums) {
    my @output = (1) x scalar @$nums;
    my $partialProduct = 1;
    for (my $i = 0; $i <= $#$nums; $i++) {
        $output[$i] = $partialProduct;
        $partialProduct *= $nums->[$i];
    }
    $partialProduct = 1;
    for (my $i = $#$nums; $i > -1; $i--) {
        $output[$i] *= $partialProduct;
        $partialProduct *= $nums->[$i];
    }
    return \@output;
}
# 462. Minimum Moves to Equal Array Elements II
sub minMoves2($nums) {
    my $le = scalar @$nums;
    @$nums = sort { $a <=> $b } @$nums;
    my $move_count = 0;
    for (my $i = 0; $i < int($le/2); $i++) {
        $move_count += $nums->[$le-1-$i] - $nums->[$i];
    }
    return $move_count;
}
# 817. Linked List Components
sub numComponents($head, $G) {
    my %G = map { $_ => 1 } @$G;
    my $c = 0;
    while ($head->{next}) {
        unless (exists $G{$head->{next}->{val}}) {
            $c++;
        }
        $head = $head->{next};
    }
    return $c + 1;
}
# 495. Teemo Attacking
sub findPoisonedDuration($timeSeries, $duration) {
    my $timePoisoned = 0;
    for (my $i = 0; $i < $#$timeSeries; $i++) {
        if ($duration <= $timeSeries->[$i+1] - $timeSeries->[$i]) {
            $timePoisoned += $duration;
        } else {
            $timePoisoned += $timeSeries->[$i+1] - $timeSeries->[$i];
        }
    }
    # last attack poison for duration always
    $timePoisoned += $duration;
    return $timePoisoned;
}
# 347. Top K Frequent Elements
sub topKFrequent($nums, $k) {
    my %mostfreq;
    foreach my $num (@$nums) {
        $mostfreq{$num}++;
    }
    #return [ (sort { $mostfreq{$b} <=> $mostfreq{$a} } keys %mostfreq)[0..$k-1] ];

    my @freq2index;
    for (keys %mostfreq) {
        unless ($freq2index[$mostfreq{$_}]) {
            $freq2index[$mostfreq{$_}] = [];
        }
        push @{$freq2index[$mostfreq{$_}]}, $_;
    }

    my @output;
    for ( reverse (0 .. $#freq2index) ) {
        last if ($k == scalar @output);
        if ($freq2index[$_]) {
            for my $n ( @{$freq2index[$_]} ) {
                push @output, int($n);
            }
        }
    }
    return \@output;
}

# 667. Beautiful Arrangement II
sub constructArray($n, $k) {
    return if $k < 2;
    my @output;
    my @arr;
    $arr[$_] = $_+1 for (0 .. $n-1);
    @output = @arr;
    # we put the last number in such a position that numbers are like this:
    # 1, n[last], 2, n[last-1], 3, ...
    # if k is even we reverse the tail, bc the tail is already +1
    for my $swappos (0 .. $k/2-1) {
        splice( @output, $swappos*2+1, 0, splice(@output, $#output) );
        if ($swappos == $k/2-1 && 0 == $k % 2) {
            splice( @output, $swappos*2+1, $#output-$swappos*2+1, reverse splice(@output, $swappos*2+1, $#output-$swappos*2+1) );
        }
    }
    return \@output;
}

# 677. Map Sum Pairs
sub mapSumCheck() {
    my $ms = MapSum->new();
    $ms->insert('apple', 3);
    print Dumper($ms->sum('app'));
    $ms->insert('app', 2);
    print Dumper($ms->sum('app'));
    print Dumper($ms->sum('go'));
}

# 46. Permutations
sub permute($nums) {
    return if $#$nums > 7;
    my @output = ();
    for (my $j = 0; $j <= $#$nums; $j++) {
        my @h = ((@$nums)[0 .. $j-1], (@$nums)[$j+1 .. $#$nums]);
        for (my $i = 0; $i < $#$nums; $i++) {
            splice(@h, 0, 0, splice(@h, $#h, 1));
            push @output, [ $nums->[$j], @h ];
        }
    }
    return \@output;
}

# 547. Friend Circles
sub findCircleNum(@M) {
    local *findFriends = sub($M, $visited, $j) {
        for (my $i = 0; $i <= $#M; $i++) {
            if (1 == $M->[$j]->[$i] && 0 == $visited->[$i]) {
                $visited->[$i] = 1;
                findFriends($M, $visited, $i);
            }
        }
    };

    my $fcnum = 0;
    my @visited = (0) x scalar @M;
    for (my $j = 0; $j <= $#M; $j++) {
        unless ($visited[$j]) {
            findFriends(\@M, \@visited, $j);
            $fcnum++;
        }
    }
    return $fcnum;
}

# 565. Array Nesting
sub arrayNesting($nums) {
    my @visited = (0)x($#$nums + 1);

    local *keepLooping = sub($nums, $idx) {
        my $c = 1;
        my $i = $nums->[$idx];
        while ($i != $idx) {
            $visited[$i] = 1;
            $c++;
            $i = $nums->[$i];
        }
        return $c;
    };

    my $max = 0;
    for (my $i = 0; $i <= $#$nums; $i++) {
       next if (1 == $visited[$i]);
       my $localMax = keepLooping($nums, $i);
       $max = $max < $localMax ? $localMax : $max;
    }

    return $max;
}
# 781. Rabbits in Forest
sub numRabbits($answers) {
    my %hm;
    my $sum = 0;
    for my $a (@$answers) {
        if (0 == $a) {
            $sum++;
        } else {
            $hm{$a} = 0 unless exists $hm{$a};
            if (0 == $hm{$a}) {
                $sum += $a + 1;
            }
            $hm{$a}++;
            # cant be more than that the same color, restart
            if ($a + 1 == $hm{$a}) {
                $hm{$a} = 0;
            }
        }
    }
    return $sum;
};

sub generateParenthesis2($n) {
    my $list = [];
    backtrack($list, "", 0, 0, $n);
    return $list;
}
sub backtrack($list, $str, $open, $close, $max) {
    print Dumper($open, $close, $str);
    if($max*2 == length($str)) {
        push @$list, $str;
        return;
    }
    if ($open < $max) {
        backtrack($list, $str.'(', $open+1, $close, $max);
    }
    if ($close < $open) {
        backtrack($list, $str.')', $open, $close+1, $max);
    }
}

################################################################
generateParenthesis2(3);
exit(0);
print Dumper(numRabbits([1,1,2]));
print Dumper(numRabbits([10,10,10]));
print Dumper(numRabbits([3,3,3,3,3,3]));
print Dumper(arrayNesting([7,4,0,3,1,6,2,5]));
print Dumper(findCircleNum([1,0,0], [0,1,0], [0,0,1]));
print Dumper(findCircleNum(
    [1,0,0,0,0,],
    [0,1,0,0,0,],
    [0,0,1,0,0,],
    [0,0,0,1,1,],
    [0,0,0,1,1,]
));
#print Dumper(permute([1,2,3,4]));
#mapSumCheck();
#print Dumper(constructArray(10, 5));
#print Dumper(constructArray([1,1,1,2,2,3], 2));
#print Dumper(topKFrequent([1,1,1,2,2,3], 2));
#print Dumper(findPoisonedDuration([1,4], 2));
#print Dumper(findPoisonedDuration([1,2,3,5], 3));
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
#print Dumper(findFrequentTreeSum({val => 5, left => { val => 2, }, right => { val => -3, }}));
#print Dumper(findFrequentTreeSum({val => 5, left => { val => 2, }, right => { val => -5, }}));
#print Dumper(findFrequentTreeSum($happyTree));
#print Dumper(findFrequentTreeSum($happyTree));
#print Dumper(shortestCompletingWord("1s3 PSt", ["step", "steps", "stripe", "stepple"]));
#print Dumper(minimumDeleteSum('delete', 'leet'));
my $prettyTree = { val => 3,
    left => { val => 5,
        left => { val => 6 },
        right => { val => 2,
            left => { val => 7 },
            right => { val => 4, }
        }
    },
    right => { val => 1,
        left => { val => 0 },
        right => { val => 8 },
    },
};
#print Dumper(subtreeWithAllDeepest($prettyTree));
#print Dumper(productExceptSelf2([1,2,3,4]));
#print Dumper(minMoves2([1,2,3,4]));
#print Dumper(numComponents({val => 0,
#    next => { val => 1, next => { val => 2, next => { val => 3, next => { val => 4,
#    next => { val => 5, next => { val => 6, next => { val => 7 }}}}}}}}, [0,2,3,5,7]));


package MapSum;
sub new($class) {
    return bless {map => {}}, $class;
}
sub insert($self, $k, $v) {
    $self->{map}->{$k} = $v;
    return $self;
}
sub sum($self, $prefix) {
    my $sum = 0;
    foreach (grep { $_ =~ /^$prefix/ } keys %{$self->{map}}) {
        $sum += $self->{map}->{$_};
    }
    return $sum;

}
