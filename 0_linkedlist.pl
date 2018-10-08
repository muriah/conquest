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

my $llist = new LinkedList();
$llist->generate([7,6,5,4,3,1]);
print Dumper($llist->_find(4));
exit(0);
$llist->_add_ordered_with_find(1)->print();
$llist->delete(7)->print();
$llist->delete(1)->print();
exit(0);
$llist->add2head(10)->add2head(9)->add2head(6)->add2tail(41);
$llist->reverse->print();
$llist->reverse->print();
$llist->add_ordered(5)->add_ordered(0)->add_ordered(-1)->add_ordered(42)->add_ordered(42)->print();

# SIMPLE LINKED LIST
package LinkedList;
use Data::Dumper;
sub new($class) {
    my $new_node;
    return bless { list => $new_node }, $class;
}
sub generate($self, $values) {
    foreach (@$values) {
        my $node = { v => $_, n => undef };
        $node->{n} = $self->{list};
        $self->{list} = $node;
    }
    return $self;
}
sub is_empty($self) {
    return 0 == scalar keys %{$self->{list}};
}
sub add2head($self, $v) {
    my $new_node = { v => $v, n => $self->{list} };
    $self->{list} = $new_node;
    return $self;
}
sub add2tail($self, $v) {
    my $next = $self->{list};
    while ($next->{n}) {
        $next = $next->{n};
    }
    $next->{n} = { v => $v, n => undef };
    return $self;
}
sub add_ordered($self, $v) {
    return $self->generate([$v]) if $self->is_empty();
    my $list = \$self->{list};
    my $curr = $self->{list};
    if ($v < $curr->{v}) {
        $self->add2head($v);
    } else {
        while (1) {
            if ($curr->{n}->{n} && $v > $curr->{n}->{v}) {
                $curr = $curr->{n};
            } else {
                # curr->next is tail and is lt $v
                if (!$curr->{n}->{n}) {
                    $curr->{n}->{n} = { v => $v, n => undef };
                    last;
                } else {
                    my $next = $curr->{n};
                    $curr->{n} = { v => $v, n => $next };
                    last;
                }
            }
        }
        $self->{list} = $$list;
    }
    return $self;
}

sub _find($self, $v) {
    return () if $self->is_empty();

    my $curr = $self->{list};
    while ($curr->{n}) {
        if ($v == $curr->{v}) {
            return (undef, $curr);
        } elsif ($v == $curr->{n}{v}) {
            last;
        } else {
            $curr = $curr->{n};
        }
    }
    return ($curr, $curr->{n});
}

sub _find_alt($self, $v) {
    my $list = $self->{list};

    return (undef, $list) if ($v == $list->{v});

    my $pred; my $elem;
    for ( $pred = $list; $elem = $pred->{n}; $pred = $elem) {
        if ($v == $elem->{v}) {
            last;
        }
    }
    return ($pred, $elem);
}

sub _add_ordered_with_find($self, $v) {
    my ($prev_node, $node) = $self->_find($v);
    unless ($node) {
        my $new_node = { v => $v, n => $prev_node->{n} };
        $prev_node->{n} = $new_node;
    }
    return $self;
}

sub delete($self, $v) {
    my ($prev_node, $node) = $self->_find($v);
    if ($node) {
        if ($prev_node) {
            $prev_node->{n} = $node->{n};
        } else {
            $self->{list} = $node->{n}
        }
    }
    return $self;
}

sub reverse($self) {
    my $list_r; # to put reversed list to
    my $list = $self->{list}; # ref to our list / ref to its head / first node
    while (my $new_node = $list) { # get first node
        $list = $list->{n}; # move to next node / head = next
        $new_node->{n} = $list_r; # put new node to the head of reversed list / its next is reversed list
        $list_r = $new_node; # reversed list head is now new node
    }
    $self->{list} = $list_r;
    return $self;
}
sub print($self) {
    print "\nhead | ";
    my $node = $self->{list};
    while ($node) {
        print $node->{v}, ' -> ';
        $node = $node->{n};
    }
    print "| tail\n";
}
