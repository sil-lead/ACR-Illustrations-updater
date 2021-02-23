#!/usr/bin/perl
unless ($^O eq "MSWin32") {
	die "This script is built for Windows\n";
}

# make sure the index.txt file has a return at the end
my $baseindexloc = "/ProgramData/SIL/ImageCollections/Afghan Children Read/index.txt";
open (my $basefh, "<", $baseindexloc) || die "Please install the ACR Illustrations collection before running this script.\n";
my @index;
while (<$basefh>) {
	chomp;
	s/\r//; # remove trailing <CR>
	push @index, $_;
};
close $basefh;

# make sure the index of new images has no header row
open (my $fh, "<", "index.txt");
while (<$fh>) {
	chomp;
	s/\r//;
	unless (/^filename/ or /^$/) {
		push @index, $_;
	}
}
close $fh;

# make sure there are no duplicate filenames
my @jndex;
push @jndex, shift (@index);
my @filtered = uniq(@index);
push @jndex, @filtered;
open (my $fh, ">", "index.txt");
for my $i (@jndex) {
	print $fh "$i\n";
}
close $fh;

sub uniq {
	my (@unique, %seen);
	for my $elem (@_) {
		my @line = split("\t", $elem);
		my $key = join("\t", @line[0..1]);
		unless ($seen{$key}) {
			push @unique, $elem;
			$seen{$key}++;
		} else {
			print "The index has a duplicate file: \n";
			print "  subfolder: $line[1]\n";
			print "  filename:  $line[0]\n";
			print "Please fix the filnames and run this script again\n";
			die;
		}
	}
	return @unique;
}
