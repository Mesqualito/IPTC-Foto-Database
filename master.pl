use strict;
use warnings;
# https://github.com/exiftool/exiftool
# http://owl.phy.queensu.ca/~phil/exiftool/
use Image::ExifTool;
use Data::Dumper;
use v5.28;

my @directories = ("/run/user/1000/gvfs/smb-share:server=n4310.local,share=daten/InHouse Produktfotos/Webshop-Bilder/ausgewählt");
my @suffixes = qw(jpg jpeg gif png raw svg tif tiff psd orf nef eps cr2 arw);

my %file_catalog = ();
while (my $folder = shift @directories) {

    opendir(DirHandle, "$folder") or die "Cannot open $folder\n";
    my @files = readdir(DirHandle);
    closedir(DirHandle);

    foreach my $file (@files) {
        my $file_string = "$folder/$file";
        if (-f $file_string) {
            my $sep_pos = rindex($file, ".");
            my $file_length = length $file;
            my $end_chars = -($sep_pos - $file_length + 1);
            my $suffix = substr $file, $sep_pos + 1, $end_chars;
            if (grep ( lc $suffix, @suffixes)) {
                my %exif_data = ();
                my $exif_tool = new Image::ExifTool;
                my $info = $exif_tool->ImageInfo($file_string);
                foreach my $key (keys %{$info}) {
                    say "Key: $key => Value: %{$info}{$key}";
                    $exif_data{$key} = %{$info}{$key};
                 }
                $file_catalog{$file_string} = %exif_data;
            }
        }
    }
}
my $hash_size = keys %file_catalog;
say "Im 'file_catalog'-Hash abgelegte Bildpfad(key)-/ Inhalt(value)-Hashes: ", $hash_size;

# copy one value of our hash into another one
my $test_entry_key = '/run/user/1000/gvfs/smb-share:server=n4310.local,share=daten/InHouse Produktfotos/Webshop-Bilder/ausgewählt/002375.JPG';
my %test_entries = ();
say Dumper(%file_catalog, $test_entry_key);
@test_entries{ $test_entry_key } = $file_catalog{ $test_entry_key };
$hash_size = keys %test_entries;
say "Im 'test_entries'-Hash abgelegte Bildpfad(key)-/ Inhalt(value)-Hashes: ", $hash_size;

# read out the test-hash
say "Exif-Daten von '$test_entry_key':";
say Dumper(%test_entries, $test_entry_key);

while (my ($key, $value) = each %{@test_entries{ $test_entry_key }}) {
    say Dumper($key, $value);
};