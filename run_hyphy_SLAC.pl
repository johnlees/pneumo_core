#!/usr/bin/perl -w

use strict;
use warnings;

my $cls_id = $ARGV[0];
my $model = $ARGV[1];

if (!-e "$cls_id/$cls_id.treefile")
{
   mkdir($cls_id);
   chdir($cls_id);
   rename("../$cls_id.aln", "$cls_id.aln");

   system("iqtree -s $cls_id.aln -pre $cls_id -m GTR");
}
else
{
   chdir($cls_id);
}
open(CMD, ">hyphy.cmd") || die("Could not write commands");
print CMD join("\n", "1", "3", "1", "/lustre/scratch118/infgen/team81/jl11/nick_data/$cls_id/$cls_id.aln", "/lustre/scratch118/infgen/team81/jl11/nick_data/$cls_id/$cls_id.treefile", "1", "0", "0.05") . "\n";
close CMD;

system("HYPHYMP < hyphy.cmd");

exit(0);

