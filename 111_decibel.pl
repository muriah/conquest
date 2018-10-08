#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use experimental 'signatures';

sub _BFS($graph, $ve) {
    my @grey;
    my %black;
    my @d = (0) x ($ve + 1);
    push @grey, [$ve];
    while (scalar @grey) {
        my $path = shift @grey;
        my $v = $path->[-1];
        print join(' -> ', @$path), "\n" unless scalar @{$graph->[$v-1]};
        foreach my $n (@{$graph->[$v]}) {
            unless (exists $black{$n}) {
                $black{$n} = 1;
                $d[$n] = $d[$v] + 1;
                my @new_path = (@$path, $n);
                push @grey, \@new_path;
            }
        }
    }
    return \@d;
}
my %black;
my @path;
sub _DFS($graph, $ve, $vefrom) {
    return if exists $black{$ve};
    print "$ve -> ";
    $path[$ve] = $vefrom;
    foreach my $vee ( @{$graph->[$ve]} ) {
        unless(exists $black{$vee}) {
            _DFS($graph, $vee, $ve);
            $black{$vee} = 1;
        }
    }
}

sub get_path2($path, $ve) {
    my @output;
    for (my $i = $ve; defined $i; $i = $path->[$i]) {
        unshift @output, $i;
    }
    return \@output;
}

#           0         1      2    3    4   5   6   7
my $graph = [[1,2,3], [5,4], [6], [7], [], [], [], []];
_BFS($graph, 0);
_DFS($graph, 0, undef);
print "\n";
print Dumper(get_path2(\@path, 7));
print Dumper(get_path2(\@path, 5));
exit(0);

sub _visit_tree_node($node) {
    print $node->{val}, "->";
}
sub _tree_traverse_worder($node, $order) {
    return unless $node;
    if (-1 == $order) { _visit_tree_node($node); }
    _tree_traverse_worder($node->{left}, $order);
    if (0 == $order) { _visit_tree_node($node); }
    _tree_traverse_worder($node->{right}, $order);
    if (1 == $order) { _visit_tree_node($node); }
}

sub _tree_traverse_nore($node, $order) {
    my @stack = ();
    # preorder
    if (-1 == $order) {
        push @stack, $node;
        while (scalar @stack) {
            my $n = pop @stack;
            _visit_tree_node($n);
            push @stack, $n->{right} if ($n->{right});
            push @stack, $n->{left} if ($n->{left});
        }
    }
    elsif (0 == $order) {
        while (scalar @stack || $node) {
            if ($node) {
                push @stack, $node;
                $node = $node->{left};
            } else {
                $node = pop @stack;
                _visit_tree_node($node);
                $node = $node->{right};
            }
        }
    } elsif (1 == $order) {
        my $lastNodeVisited;
        while (scalar @stack || $node) {
            if ($node) {
                push @stack, $node;
                $node = $node->{left};
            } else {
                my $next_node = $stack[-1];
                # we are going from left // if from right lastvisited would be node->right
                if ($next_node->{right} && $lastNodeVisited != $next_node->{right}) {
                    $node = $next_node->{right};
                } else {
                    _visit_tree_node($next_node);
                    $lastNodeVisited = pop @stack;
                }
            }
        }
    }
}

#    1
#   / \
#  2   3
# /   / \
#4   5   6
#   /
#  7
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
my $wtfTree = { val => 1,
    right => { val => 2, left => { val => 3 } }
};
print "\n-PRE-order:\n";
_tree_traverse_worder($happyTree, -1);
print "\n";
_tree_traverse_nore($happyTree, -1);
print "\n...\n";
print "\n-IN-order:\n";
_tree_traverse_worder($happyTree, 0);
print "\n";
_tree_traverse_nore($happyTree, 0);
print "\n...\n";
print "\n-POST-order:\n";
_tree_traverse_worder($happyTree, 1);
print "\n";
_tree_traverse_nore($happyTree, 1);
print "\n...\n";
