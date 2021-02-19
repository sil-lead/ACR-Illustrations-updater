#!/usr/bin/perl
unless ($^O eq "MSWin32") {
	die "This script is built for Windows\n";
}

# make sure the index.txt file has a return at the end
my $baseindexloc = "/ProgramData/SIL/ImageCollections/Afghan Children Read/index.txt";
open (my $basefh, "<", $baseindexloc) || die $0;
my @index;
while (<$basefh>) {
	chomp;
	push @index, $_;
};
close $basefh;

# make sure the index of new images has no header row
open (my $fh, "<", "index.txt");
while (<$fh>) {
	chomp;
	unless (/^filename/) {
		push @index, $_;
	}
}
close $fh;

my @filtered;
push @filtered, shift (@index);
push @filtered, uniq (@index);
open (my $fh, ">", "index.txt");
for my $i (@filtered) {
	print $fh "$i\n";
}
close $fh;

sub uniq {
	my %seen;
	grep !$seen{$_}++, @_;
}
