#!/bin/bash

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

GATK="" # Please input path to GATK

REFERENCE=../../download/refs/canFam3.fa

Chrom=chr$1
InDir=$2
OutDir=$3


java -jar -Xmx16G ${GATK} \
-T VariantFiltration \
-R ${REFERENCE} \
-V ${InDir}/5GS_5TM_joint_${Chrom}.vcf.gz \
--filterExpression "AN < 20" --filterName "MissingCalledGenotypes" \
--filterExpression "DP < 75 || DP > 225 " --filterName "DPFilter" \
-o ${OutDir}/5GS_5TM_joint_${Chrom}_HighQualSites.vcf.gz
