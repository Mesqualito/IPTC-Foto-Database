use strict;
use warnings FATAL => 'all';
use Image::ExifTool ':Public';
use v5.28;

my $info = ImageInfo("/run/user/1000/gvfs/smb-share:server=n4310.local,share=daten/InHouse Produktfotos/Webshop-Bilder/ausgewählt/002375.JPG");
foreach (keys %$info) {
    print "$_ : $info->{$_}\n";
}


my %prices = ();
$prices{"pizza"} = 12.00;
$prices{"coke"} = 1.25;
$prices{"sandwich"} = 3.00;

my $size = keys %prices;
say "The hash contains $size elements.\n";
