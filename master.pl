use strict;
use warnings;
# https://github.com/exiftool/exiftool
# http://owl.phy.queensu.ca/~phil/exiftool/
use Image::ExifTool;
use Data::Dumper;
use Data::Types qw(:all);
use v5.28;

my @directories = ("/home/jhassfurter/Bilder");
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
                my $exif_tool = new Image::ExifTool;
                my $info = $exif_tool -> ImageInfo($file_string);
                say "Datei: $file_string";
                foreach my $key (keys %{$info}) {
                    say "Key: $key => Value: %{$info}";
                    foreach my $innerkey (keys %{$info}){
                        say "Inner key: $innerkey, inner value: ", $info{$key}{$innerkey}};
                    }

                }
                %file_catalog = ( $file_string => $info );
            }
        }
    }
}

my $hash_size = keys %file_catalog;
print "\n---------------------------\n";
print "Im 'file_catalog'-Hash abgelegte Bildpfad(key)-/ Inhalt(value)-Hashes: ", $hash_size;
print "\n---------------------------\n";

# read out referenced hash per file-entry with '%{$...}'
my ($i, $j) = 0;
foreach my $key (sort keys %file_catalog) {
    $i++;
    say "$i. key: $key";
    foreach my $value (keys %{$file_catalog{ $key }}) {
        $j++;
        say "$j. inner key: $key, subject: $value: $file_catalog{$key}{$value}";
    }
}