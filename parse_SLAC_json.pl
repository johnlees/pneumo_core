#!/usr/bin/perl -w

use strict;
use warnings;

my $file_in = $ARGV[0];
open(IN, $file_in) || die("Could not open $file_in");

my ($omega, $sites, $dn, $ds);
FILEREAD:
while (my $line_in = <IN>)
{
   chomp $line_in;
   if ($line_in =~ /non-synonymous\/synonymous rate ratio/)
   {
      my $next_line = <IN>;
      chomp $next_line;
      $next_line =~ /\[(.+),.+\]$/;
      $omega = $1;
   }
   elsif ($line_in =~ /MLE/)
   {
      while (my $mle_lines = <IN>)
      {
         chomp $mle_lines;
         if ($mle_lines =~ /AVERAGED/)
         {
            while (my $site_lines = <IN>)
            {
               chomp $site_lines;
               if ($site_lines =~ /\[.+, .+, (.+), (.+), .+, .+, .+, .+, .+, .+, .+\]/)
               {
                  $sites++;
                  $ds += $1;
                  $dn += $2;
               }
               else
               {
                  last FILEREAD;
               }
            }
         }
      }
   }
}

print ("sites(codons),syn,nonsyn,omega\n");
print join(",", $sites, $ds, $dn, $omega) . "\n";

exit(0);

