#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

use experimental 'signatures';

# $list_length
sub generate_list_kv_tsv($list_length = 10, $key_count = 5) {
    my @list;
    for my $i (1 .. $list_length) {
        push @list, join("\t", map { sprintf("key%s=value%s", $_, $_+$i) } (0 .. $key_count-1));
    }
    return \@list;
}
# $list[] - array to print
sub print_list($list) {
    print Dumper($list);
}
# $list [] array
sub convert_list($list = []) {
    my @converted = ();
    my $t = $list->[0];
    if ($t =~ /(?:key\d+=(\w+))/ig) {
        print "kv-tsv\n";
        for (0 .. scalar @$list-1) {
            push @converted, join(', ', ($list->[$_] =~ /(?:key\d+=(\w+))/ig));
        }
    }
    elsif ($t =~ /(\w+)\,\s*?/ig) {
        print "csv\n";
        for (0 .. scalar @$list-1) {
            my @t = ($list->[$_] =~ /(\w+)(?:\,\s*)?/ig);
            my $i = 0;
            push @converted, join("\t", map { ++$i; sprintf('key%s=%s', $i % scalar @t + 1, $_); } @t);
        }
    } else {
        print "!unknown format\n";
    }
    return \@converted;
}

my $list = [];

print "Enter `r` to regenerate list || `rk` to convert list back and forth || `x` to exit\n";
while (1) {
    my $input = <STDIN>;
    chomp $input;
    exit 0 if ('x' eq $input);
    do {
        $list = generate_list_kv_tsv();
        print_list($list);
        print_list(convert_list($list));
        print "--\n";
        print "\n\n";
    } if ('r' eq $input);
    do {
        $list = convert_list($list);
        print_list($list);
        print "--\n";
        print "\n\n";
    } if ('rk' eq $input);

}
