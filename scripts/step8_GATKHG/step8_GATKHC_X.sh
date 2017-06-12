#! /bin/bash

# This script is for the X chromosomes (chrX)

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

GATK="" # Please give path to GATK

REFERENCE=../../download/refs/canFam3.fa

Chrom='chrX'
Individual=$1
BamDir=$2
OutDir=$3

java -jar -Xmx16G ${GATK} \
-T HaplotypeCaller \
-R ${REFERENCE} \
-ERC BP_RESOLUTION \
-mbq 20 \
-out_mode EMIT_ALL_SITES \
--dontUseSoftClippedBases \
-L ${Chrom} \
-I ${BamDir}/${Individual}/${Individual}_BQSR_round3_recal.bam \
-o ${OutDir}/${Individual}/${Individual}_${Chrom}_GATK_HC.g.vcf.gz
