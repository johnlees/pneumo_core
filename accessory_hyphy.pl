#!/usr/bin/perl -w

use strict;
use warnings;

use File::Temp qw/ tempfile tempdir /;
use File::Copy "cp";

sub clean_aln($)
{
   my ($aln_file) = @_;
   open(ALN, $aln_file) || die("Could not open $aln_file");

   #my $clean_aln = File::Temp->new();
   open(my $clean_aln, '>', "$aln_file.tmp") || die("Could not open tmp file");
   while (my $line = <ALN>)
   {
      chomp $line;
      if ($line =~ /^>(.+) .+$/)
      {
         print $clean_aln ">$1\n";
      }
      else
      {
         print $clean_aln "$line\n";
      }
   }
   close ALN;
   close $clean_aln;
   #cp($clean_aln->filename, $aln_file);
   cp("$aln_file.tmp", $aln_file);
}

my $jobnr = $ENV{'LSB_JOBINDEX'};
my $sed_cmd = "sed '$jobnr" . "q;d' cls_list.txt";
my $cls_id = `$sed_cmd`;
chomp $cls_id;

if (!-d $cls_id)
{
   mkdir($cls_id);
}

system("python3 accessory_extract.py $cls_id $cls_id");

chdir($cls_id);
rename("../$cls_id.aa.fa", "$cls_id.aa.fa");
rename("../$cls_id.dna.fa", "$cls_id.dna.fa");

clean_aln("$cls_id.dna.fa");
clean_aln("$cls_id.aa.fa");

system("muscle -in $cls_id.aa.fa -out $cls_id.aa.aln");
system("revtrans.py $cls_id.dna.fa $cls_id.aa.aln > $cls_id.dna.aln");
system("iqtree -s $cls_id.dna.aln -pre $cls_id -m GTR");

open(CMD, ">hyphy.cmd") || die("Could not write commands");
print CMD join("\n", "1", "3", "1", "/lustre/scratch118/infgen/team81/jl11/pdoc/conservation/bacteriocins/$cls_id/$cls_id.dna.aln", "/lustre/scratch118/infgen/team81/jl11/pdoc/conservation/bacteriocins/$cls_id/$cls_id.treefile", "1", "0", "0.05") . "\n";
close CMD;

system("HYPHYMP < hyphy.cmd");

exit(0);

