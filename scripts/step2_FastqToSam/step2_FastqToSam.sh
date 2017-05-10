#!/bin/bash

Individual=$1
FastqDir=$2
OutDir=$3

picard FastqToSam \
FASTQ=${FastqDir}/${Individual}/${Individual}_1.fastq.gz \
FASTQ2=${FastqDir}/${Individual}/${Individual}_2.fastq.gz \
OUTPUT=${OutDir}/${Individual}/${Individual}_FastqToSam.bam \
READ_GROUP_NAME=${Individual}_1a \
SAMPLE_NAME=${Individual} \
LIBRARY_NAME=Lib1 \
PLATFORM=illumina \
