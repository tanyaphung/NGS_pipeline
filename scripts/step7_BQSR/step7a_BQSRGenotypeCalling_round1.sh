#! /bin/bash

# Step 7a: Genotype calling with GATK UG round 1

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

GATK="/u/project/klohmuel/tanya_data/softwares/GenomeAnalysisTK.jar"

REFERENCE=../../download/refs/canFam3.fa

Individual=$1
InBamDir=$2
OutBamDir=$3
NumRound=$4


java -jar -Xmx16G ${GATK} \
-T UnifiedGenotyper \
-nt 12 \
-R ${REFERENCE} \
-I ${InBamDir}/${Individual}/${Individual}_RemoveBadReads.bam \
-o ${OutBamDir}/${Individual}/${Individual}_BQSRGenotypeCalling_${NumRound}.vcf.gz \
-glm BOTH \
--min_base_quality_score 20 \
-metrics ${OutBamDir}/${Individual}/${Individual}_BQSRGenotypeCalling_${NumRound}.vcf.gz.metrics 
