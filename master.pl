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
                my %exif_data = ();
                my @helper = ();
                my $exif_tool = new Image::ExifTool;
                my $info = $exif_tool->ImageInfo($file_string);

                # read out referenced hash per file-entry with '%{$...}'
                foreach my $key (sort keys %{ $info }) {
                    foreach my $subject (keys %{ $info{ $key } }) {
                        say "Key: $key, subject: $subject: $info{$key}{$subject}";
                    }
                }
            }
            # to avoid flattening if read out again
            # use reference:
            # my $nested_exif_data = \%exif_data;
            # say "Key ist: '$file_string'";
            # %file_catalog = $nested_exif_data->{ q($file_string) };
        }

    }
}


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