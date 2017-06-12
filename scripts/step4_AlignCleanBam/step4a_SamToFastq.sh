#!/bin/bash

REFERENCE=../../download/refs/canFam3.fa

Individual=$1
InDir=$2
OutDir=$3

picard SamToFastq \
I=${InDir}/${Individual}/${Individual}_MarkAdapters.bam \
FASTQ=${OutDir}/${Individual}/${Individual}_CleanBamToFastq.fastq \
CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \
2>>${OutDir}/${Individual}/${Individual}_Process_SamToFastq.txt \
