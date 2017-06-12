#!/bin/bash

PICARD=/u/home/p/phung428/miniconda2/envs/SexBiased/share/picard-2.9.0-0/picard.jar
REFERENCE=../../download/refs/canFam3.fa
Individual=$1
AlignedBamDir=$2
UnmappedBamDir=$3
OutDir=$4

java -Xmx16G -jar ${PICARD} MergeBamAlignment \
ALIGNED_BAM=${AlignedBamDir}/${Individual}/${Individual}_BwaMem.bam \
UNMAPPED_BAM=${UnmappedBamDir}/${Individual}/${Individual}_FastqToSam.bam \
OUTPUT=${OutDir}/${Individual}/${Individual}_AlignCleanBam.bam \
R=$REFERENCE CREATE_INDEX=true \
ADD_MATE_CIGAR=true CLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true \
INCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 \
PRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS \
2>>${OutDir}/${Individual}/${Individual}_Process_MergeBam.txt
