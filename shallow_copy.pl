#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

# - a hash
# - create a reference to it
# - place that reference in a scalar

my $hashref = {data => "a"};

# no references embedded in the hash behind hashref will be copied to the hash_copy
my %hash_copy = %{$hashref}; # Create a copy of the hash that $hashref points to
my $hashref_copy = \%hash_copy; # Ref to %hash_copy
$hashref_copy->{data} = "b";

print "$hashref->{data}\n"; # Outputs 'a'
print "$hashref_copy->{data}\n"; # Outputs 'b'