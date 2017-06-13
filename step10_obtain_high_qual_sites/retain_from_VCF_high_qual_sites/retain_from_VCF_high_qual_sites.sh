#!/bin/bash

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

GATK="" # Please input path to GATK

REFERENCE=../../download/refs/canFam3.fa

Chrom=chr$1
InFile=$2
OutFile=$3
Bed=$4


java -jar -Xmx16G ${GATK} \
-T SelectVariants \
-R ${REFERENCE} \
-L ${Bed} \
-V ${InFile} \
-o ${OutFile}
