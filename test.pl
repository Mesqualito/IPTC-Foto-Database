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



# -----------------------------------------------------------------------------------

my $hash_size = keys %file_catalog;
say "Im 'file_catalog'-Hash abgelegte Bildpfad(key)-/ Inhalt(value)-Hashes: ", $hash_size;

# copy one value of our hash into another one
my $test_entry_key = '/run/user/1000/gvfs/smb-share:server=n4310.local,share=daten/InHouse Produktfotos/Webshop-Bilder/ausgewählt/002375.JPG';
my %test_entries = ($test_entry_key => $file_catalog{ $test_entry_key });
$hash_size = keys %test_entries;
say "Im 'test_entries'-Hash abgelegte Bildpfad(key)-/ Inhalt(value)-Hashes: ", $hash_size;

# read out the test-hash
say "Exif-Daten von '$test_entry_key':";
# Dereference the hash from the hash:
print "$test_entries{$test_entry_key}->{'Title'}";