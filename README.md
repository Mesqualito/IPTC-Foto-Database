# IPTC-Foto-Database
Extract Exif/IPTC-Metadata, save it with the path of the picture and write it to other pictures (via eq IPTC-'title')

This project aims to read all fotos from a folder including all subfolders, extract their metadata and save it into a CouchDB.
At app start the program should ask about "overwritting" existing _id's (of course with other rev's) or create a new uuid
every time a document is stored.

It is written in Perl. But Perl is a bad thing if you don't use it regularly: save hashes in hashes, reference them,
save the reference in a scalar and flip out while trying to understand why you can't give a hash into a "sub", but only
a reference, go crazy with all that @•$•%•%$•$$ - the code looks like a MAD Comic and therefore
you'll also start giggling after a while...
