#!/usr/bin/perl -w

use strict;
use warnings;

my $aln = $ARGV[0];

open(ALN, $aln) || die("Could not open $aln\n");
my $length = 0;
my @lengths;
while (my $line_in = <ALN>)
{
   chomp $line_in;
   if ($line_in =~ /^>/)
   {
      push(@lengths, $length);
      $length = 0;
   }
   else
   {
      $line_in =~ s/-//g;
      $length += length($line_in);
   }
}
push(@lengths, $length);

shift(@lengths);
my $avg = 0;
for my $len (@lengths)
{
   $avg += $len;
}
$avg /= scalar(@lengths);

print STDERR "Average length of " . scalar(@lengths) . " sequences:\n";
print $avg . "\n";

exit(0);

