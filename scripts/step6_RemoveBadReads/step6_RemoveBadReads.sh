#!/bin/bash

# Optional step to remove bad reads prior to BQSR.
# samtools options:
# -h: include the header in the output
# -b: output in the BAM format
# -f: only output alignments with all bits set in INT present in the FLAG field.
# -F: Do not output alignments with any bits set in INT present in the FLAG field. 
# -q: skip alignments with MAPQ smaller than INT

Individual=$1
InDir=$2
OutDir=$3

samtools view -hb -f 2 -F 256 -q 30 ${InDir}/${Individual}/${Individual}_MarkDups.bam | samtools view -hb -F 1024 > ${OutDir}/${Individual}/${Individual}_RemoveBadReads.bam


picard BuildBamIndex \
VALIDATION_STRINGENCY=LENIENT \
I=${OutDir}/${Individual}/${Individual}_RemoveBadReads.bam
