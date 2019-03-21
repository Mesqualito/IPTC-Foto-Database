use strict;
use warnings;
# https://github.com/exiftool/exiftool
# http://owl.phy.queensu.ca/~phil/exiftool/
use Image::ExifTool;
use Data::Dumper;
use v5.28;

my @directories = ("/home/jhassfurter/Bilder");
my @suffixes = qw(jpg jpeg gif png raw svg tif tiff psd orf nef eps cr2 arw);

my %file_catalog = ();
while (my $folder = shift @directories) {

    opendir(DirHandle, "$folder") or die "Cannot open $folder\n";
    my @files = readdir(DirHandle);
    closedir(DirHandle);
    my $i = 1;
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

                # read out referenced hash per file-entry with '%{$...}'
                foreach my $key (keys %{$info}) {
                    say "Key: $key -> Value: ", $info->{ $key };
                    %exif_data = $info->{ $key };
                }
                # to avoid flattening if read out again
                # use reference:
                my $nested_exif_data = \%exif_data;
                %file_catalog = ($file_string => $nested_exif_data);
                say "$i. Eintrag für '$file' in '\%file_catalog' geschrieben.";
                $i++;
            }

        }
    }
}
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

################## Array reference cheatsheet ##################
#                                                              #
#  Array: @names                                               #
#  create reference: $names_ref = \@names                      #
#  array-reference: $names_ref                                 #
#                                                              #
#                      Array                Array Reference    #
#  Whole array:        @names               @{ $names_ref }    #
#  Element of array:   $names[0]            ${ $names_ref }[0] #
#                                           $names_ref->[0]    #
#  Size of array:      scalar @names        scalar @$names_ref #
#  Largest index:      $#names              $#$names_ref       #
#                                                              #
################################################################

# use $foo->(args) instead of &$foo(args)
# use $foo->[subscript] instead of $$foo[subscript]
# use $foo->{subscript} instead of $$foo{subscript}
# prefer $foo = value if !defined($foo);
# over $foo //= value;
# use if (!cond) {
# over unless (cond) {
# use foreach instead of for when looping over a list of elements.