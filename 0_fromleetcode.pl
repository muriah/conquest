#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use experimental 'signatures';

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


#print Dumper(spiralMatrixIII(5, 6, 2, 4));
#print Dumper(customSortString('cba', 'abcdfbca'));
#print Dumper(findDuplicates([4,3,2,7,8,1,3,1]));
#print Dumper(stoneGame([4,3,2,7,8,1,3,4]));
#print Dumper(reconstructQueue( [[7,0], [4,4], [7,1], [5,0], [6,1], [5,2]] ));
#print Dumper(canVisitAllRooms( [[1,3],[3,0,1,2],[2],[0]] ));
#print Dumper(canVisitAllRooms( [[1,3],[3,0,1],[2],[0]] ));
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
print Dumper(largestValues($happyTree));
print Dumper(largestValues($awesomeTree));
