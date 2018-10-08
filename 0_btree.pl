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

# LINKED LIST

# $arr [number,..]
sub tree_build($arr) {
    my @temp = sort { $a <=> $b } @$arr;
    my ($median) = splice(@temp, int($#$arr/2), 1);
    my $root = { k => $median, l => undef, r => undef };
    my $tree = $root;
    for my $i ( 0 .. $#temp ) {
        add2tree($tree, $temp[$i]);
    }
    return $tree;
}

sub add2tree($tree, $key) {
    my $new_node = { k => $key, l => undef, r => undef };
    my $node = $tree;
    while ($node) {
        if ($node->{k} > $key) {
            if ($node->{l}) {
                $node = $node->{l};
            } else {
                $node->{l} = $new_node;
                return $tree;
            }
        } else {
            if ($node->{r}) {
                $node = $node->{r};
            } else {
                $node->{r} = $new_node;
                return $tree;
            }
        }
    }
}

sub traverse($node, $ipp = 0) {
    return unless $node;
    printf("[%s]\t",  $node->{k}) if (-1 == $ipp);

    traverse($node->{l}, $ipp);

    printf("[%s]\t",  $node->{k}) if (0 == $ipp);

    traverse($node->{r}, $ipp);

    printf("[%s]\t",  $node->{k}) if (1 == $ipp);
}

my $nodes = [1001,11,99,123,6,100,999,0,124];
my $tree = tree_build($nodes);
print "\nin-order\t";
traverse($tree);
print "\npre-order\t";
traverse($tree, -1);
print "\npost-order\t";
traverse($tree, 1);
print "\n";
