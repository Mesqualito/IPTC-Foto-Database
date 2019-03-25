#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

print "Content-type: text/html\n\n";
print "<html><h1>Hello!</h1></html>\n";

# readout from tables

my %exif_data = ('Title' => '006347-2', 'Subject Code' => 'Webshop_1');

my %pictures = ('some-path/some-pic.jpg' => {'Title' => '006347-2', 'Subject Code' => 'Webshop_1'},
    'some-other-path/some-other-pic' => {'Title' => '025002-5', 'Subject Code' => 'Webshop_2'});

print "$pictures{'some-path/some-pic.jpg'}->{'Title'}";




