#!/usr/bin/env python
# -*- coding: ASCII -*-
#

# python libs
import os,sys
import dendropy
import re
import subprocess
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

jobnr = int(os.getenv('LSB_JOBINDEX', 1))
alignment_file_list = []
with open("alignment_files.txt") as alignment_files:
    for alignment_file in alignment_files:
        alignment_file = re.sub('\.aln$', '', alignment_file.rstrip())
        alignment_file_list.append(alignment_file)

alignment_file = alignment_file_list[jobnr-1]
os.chdir(alignment_file)
# translate
with open(alignment_file + ".aa.fa", "w") as aa_out:
    with open(alignment_file + ".aln") as dna_in:
        for record in SeqIO.parse(dna_in, "fasta"):
            aa_seq = re.sub('-', '', str(record.seq))
            if len(aa_seq) % 3:
                aa_seq = aa_seq[0:-(len(aa_seq) % 3)]
            new_record = SeqRecord(Seq(aa_seq).translate(gap="-"),
                                   id = record.id)
            SeqIO.write(new_record, aa_out, "fasta")

subprocess.call('muscle -in ' + alignment_file + ".aa.fa -out " + alignment_file + ".aa.aln", shell=True)
aa_aln = dendropy.ProteinCharacterMatrix.get(file=open(alignment_file + ".aa.aln"), schema="fasta")
with open("aa_pi.txt", "w") as output_file:
    output_file.write("\t".join([alignment_file, str(dendropy.calculate.popgenstat.nucleotide_diversity(aa_aln))]) + "\n")

os.chdir("..")

sys.exit(0)
