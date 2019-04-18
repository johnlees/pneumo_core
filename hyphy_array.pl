#!/usr/bin/perl -w

use strict;
use warnings;

my $job_nr = $ENV{'LSB_JOBINDEX'};
my $sed_cmd = "sed '$job_nr" . "q;d' alignment_files.txt";
my $cls = `$sed_cmd`;
chomp $cls;
$cls =~ m/^(CLS\d+)\.aln$/;

my $hyphy_cmd = "perl run_hyphy_SLAC.pl $1";
system($hyphy_cmd);

exit(0);

