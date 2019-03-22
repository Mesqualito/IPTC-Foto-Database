use strict;
use warnings;
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
            my $end_chars = -($sep_pos - (length $file) + 1);
            my $suffix = substr $file, $sep_pos + 1, $end_chars;
            if (grep ( lc $suffix, @suffixes)) {
                my $exif_tool = new Image::ExifTool;
                my $info = $exif_tool->ImageInfo($file_string);
                say "Datei: $file_string";
                $file_catalog{$file_string} = $info;
            }
        }
    }
}

my $hash_size = keys %file_catalog;
print "\n---------------------------\n";
print "In 'file_catalog'-hash recorded image-path (key)-/ exif-data (value)-hashes: ", $hash_size;
print "\n---------------------------\n";

my ($i, $j) = 0;
foreach my $key (sort keys %file_catalog) {
    $i++;
    printf "%s. key: $key\n", uc chr($i + ord('A') - 1 );
    foreach my $inner_key (keys %{$file_catalog{ $key }}) {
        $j++;
        say "$j. inner key: $inner_key: $file_catalog{$key}{$inner_key}";
    }
}