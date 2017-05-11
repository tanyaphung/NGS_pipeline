#!/bin/bash

Individual=$1
BamDir=$2
OutDir=$3

picard MarkIlluminaAdapters \
I=${BamDir}/${Individual}/${Individual}_FastqToSam.bam \
O=${OutDir}/${Individual}/${Individual}_MarkAdapters.bam \
M=${OutDir}/${Individual}/${Individual}_MarkAdapters.bam_metrics.txt
