#!/bin/bash

REFERENCE=../../download/refs/canFam3.fa

Individual=$1
Dir=$2

bwa mem -M -t 3 -p $REFERENCE ${Dir}/${Individual}/${Individual}_CleanBamToFastq.fastq 2>> ${Dir}/${Individual}/${Individual}_Process_BwaMem.txt > ${Dir}/${Individual}/${Individual}_BwaMem.bam
