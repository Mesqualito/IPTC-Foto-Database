use strict;
use warnings;
use Image::ExifTool;
use Data::Dumper;
use Data::Types qw(:all);
use v5.28;
use lib './lib';
use Store::CouchDB;
use Mojo::JSON qw(encode_json decode_json);

my @directories = ("/home/jhassfurter/Bilder/GENERICA");
my @suffixes = qw(jpg jpeg gif png raw svg tif tiff psd orf nef eps cr2 arw);
my $db = CouchDB->new('localhost', '5984');
$db->put("fotodb");

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
                # a new ExifTool-Instance
                my $exif_tool = new Image::ExifTool;
                # http://owl.phy.queensu.ca/~phil/exiftool/ExifTool.html
                # "The $info value returned by ImageInfo in the above examples is a reference to a hash containing
                # the tag/value pairs."
                my $info = $exif_tool->ImageInfo($file_string);
                # https://www.cs.mcgill.ca/~abatko/computers/programming/perl/howto/hash
                my %couch_put = ();
                $couch_put{ _id } = $file;
                foreach (keys %$info) {
                    $couch_put{ $_ } = $$info{$_};
                    say "$_ => $couch_put{ $_ }";

                }
                my $complete_put = \%couch_put;
                $complete_put = encode_json $complete_put;
                say "JSON-String: $complete_put";
                $db->put("fotodb/$file", $complete_put);
            }
        }
    }
}