#!/usr/bin/perl

# ACR-process-images.#!/usr/bin/env perl
# Author: Fraser Bennett fraser_bennett@sil-lead.org
# Date: 18-Feb-2021
# Copyright (c) SIL LEAD, Inc.
# Licensed under MIT License
# based on https://github.com/sillsdev/image-collection-starter

unless ($^O eq "MSWin32") {
	die "This script is for use on Microsoft Windows\r\n";
}

#  For this script to work, the following locations have to be in the Windows
# PATH environment variable (hopefully the installers will do that for you?):
# imagemagick, exiftool, pngout

#  ----------- BEGIN LINES THAT YOU NORMALY CUSTOMIZE FOR EACH COLLECTION -------------------------

$COPYRIGHT = "Copyright (c) 2020 The Ministry of Education of the Government of the Islamic Republic of Afghanistan";
$LICENSE = "All rights reserved";
$ATTRIBUTIONURL = "";
$COLLECTIONURI = "";
$COLLECTIONNAME = "Afghan Children Read Illustrations";
#  The following line is optional; you might like to prefix all images with something indicating the collection it came from.
#  If not, set to just PREFIX=
$PREFIX = "";
#  The following line is optional, if you want to watermark each image. Otherwise, set to ""
#  Note that the approach used below is pretty ugly, and we don't use it for Art Of Reading.
#  It would not be hard to instead have a the watermark done as a semi-transparent image instead of this black text.
#  But either way, it's going to expand/shrink with the image, so it is not so practical.
$WATERMARK = "";

#  ----------- END OF LINES THAT YOU NORMALY CUSTOMIZE FOR EACH COLLECTION -------------------------

$source = "images/";
$dest = 'output/processed-images/';
if ($^O eq "MSWin32") {
	$source =~ s/\//\\/g;
	$dest =~ s/\//\\/g;
}
# Convert forward to back slashes so that rmdir and xcopy will
# know the destination is a directory

#  Clear out existing /processed-images
`rmdir /S /Q $dest` ;
# `rm -R $dest`;

#  copy the source images to /processed-images
`xcopy $source $dest /S /Q /I` ;
# `cp -R $source $dest`;

#remove placeholder .md files in ACR-images
my @md = `dir /b /s /a:-d $dest\*.md`;
chomp @md;
for (@md) {
	`del "$_";`
}

my @images = `dir /b /s /a:-d $dest\*.jpg $dest\*.png $dest\*.tif $dest\*.bmp`;
chomp @images;
for (@images) {
    my $src = $_;
	my $result = $src;

	$result = $prefix . $result;

	# whatever the filename was, the new file name is that with the prefix
	# (if any) plus the .png extension
	($result = $src) =~ s/(tif|bmp|png)$/png/i;

	# convert each file that looks like an image to PNG unless it's a jpg,
	# because you probably don't want to convert those to PNG
	unless ($src =~ /png$/i or $src =~ /jpg$/i) {
		`magick convert "$src" "$result"`;
	}

	# if we've made a copy with a different name,
	# remove the original from /process-images
	unless ($result eq $src) {
		`del "$src"`;
	}
	
	# and compress the resulting PNG file
	if ($result =~ /png$/i) {
		print "Compresssing $result\r\n";
		`pngout /y /v /s1 /kEXt,zTXt "$result"`;
	}

	# use imagemagick convert to add a watermark
	if ($WATERMARK) {
		print "Adding a watermark to $result...\n";
		`magick convert -pointsize 20 -gravity SouthWest -annotate +10+10 $WATERMARK "$result" "$result"`;
	}

	# add metadata
    print "Embedding metadata in $result...\n";
	`exiftool -E -q -overwrite_original_in_place -copyright="$COPYRIGHT" -XMP-cc:License="$LICENSE" -XMP:Marked="True" -XMP:ReuseAllowed="true" -XMP:AttributionUrl="$ATTRIBUTIONURL" -XMP:CollectionURI="$COLLECTIONURI" -XMP:CollectionName="$COLLECTIONNAME" "$result"`;
}
