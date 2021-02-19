#!/usr/bin/perl

unless ($^O eq "MSWin32") {
	die "This script is for use on Microsoft Windows\r\n";
}

#  For this script to work, the following locations have to be in the Windows
# PATH environment variable (hopefully the installers will do that for you?):
# imagemagick, exiftool, pngout

#  ----------- BEGIN LINES THAT YOU NORMALY CUSTOMIZE FOR EACH COLLECTION -------------------------

$COPYRIGHT = "Copyright (c) 2021 My Organization";
$LICENSE = "http://creativecommons.org/licenses/by-sa/4.0/";
$ATTRIBUTIONURL = "http://myOrganization.org";
$COLLECTIONURI = "http://myOrganization.org/aboutShapesImages";
$COLLECTIONNAME = "Shapes Images";
#  The following line is optional; you might like to prefix all images with something indicating the collection it came from.
#  If not, set to just PREFIX=
$PREFIX = "shape_";
#  The following line is optional, if you want to watermark each image. Otherwise, set to ""
#  Note that the approach used below is pretty ugly, and we don't use it for Art Of Reading.
#  It would not be hard to instead have a the watermark done as a semi-transparent image instead of this black text.
#  But either way, it's going to expand/shrink with the image, so it is not so practical.
$WATERMARK = "Shapes.CC-BY-SA";
#  ----------- END OF LINES THAT YOU NORMALY CUSTOMIZE FOR EACH COLLECTION -------------------------

$source = "images";
$dest = 'output/processed-images';
# It is important to include the trailing slash / so that xcopy (below) will
# know the destination is a directory

#  Clear out existing /processed-images
`rmdir /S /Q $dest` ;
# `rm -R $dest`;

#  copy the source images to /processed-images
`xcopy $source $dest /S /Q /I` ;
# `cp -R $source $dest`;

my @images = `dir /b /s $dest *.jpg *.png *.tif *.bmp`;
for (@images) {
    chomp;
    my $src = $_;
		my $result = $_;
		unless ($src =~ /\.jpg$/i) {
			# whatever the filename was, the new file name is that with the prefix
			# (if any) plus the .png extension
			my $result = $src =~ s/jpg$/png/i;
			# if we've made a copy with a different name,
			# remove the original from /process-images
			`del $src`;

			# convert each file that looks like an image to PNG unless it's a jpg,
			# because you probably don't want to convert those to PNG
			`magick convert $src $result`;

			# and compress the resulting PNG file
			print "Compresssing $result\n";
			`pngout /y /v /s1 /kEXt,zTXt $result`;
		}

		# use imagemagick convert to add a watermark
		if ($WATERMARK) (
			`magick convert -pointsize 20 -gravity SouthWest -annotate +10+10 $WATERMARK $result $result`;
		)

		# add metadata
    print "Embedding metadata in $src...\n";
		`exiftool -E -q -overwrite_original_in_place -copyright="$COPYRIGHT" -XMP-cc:License="$LICENSE" -XMP:Marked="True" -XMP:ReuseAllowed="true" -XMP:AttributionUrl="$ATTRIBUTIONURL" -XMP:CollectionURI="$COLLECTIONURI" -XMP:CollectionName="$COLLECTIONNAME" $src`;
}
