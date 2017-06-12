#! /bin/bash

# Step 7b: Make recalibration table with GATK Base Recalibrator
# This is for round 1

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

GATK="/u/project/klohmuel/tanya_data/softwares/GenomeAnalysisTK.jar"

REFERENCE=../../download/refs/canFam3.fa

Individual=$1
InBamDir=$2
OutBamDir=$3
NumRound=$4

java -jar -Xmx42G ${GATK} \
-T BaseRecalibrator \
-nct 12 \
-R ${REFERENCE} \
-I ${InBamDir}/${Individual}/${Individual}_RemoveBadReads.bam \
-o ${OutBamDir}/${Individual}/${Individual}_BQSR_${NumRound}_recal.table \
-knownSites ${OutBamDir}/${Individual}/${Individual}_BQSRGenotypeCalling_${NumRound}.vcf.gz
