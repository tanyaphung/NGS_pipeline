#! /bin/bash

# This script is for the autosomes (chr 1 to 38)

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

GATK="" # Please give the path to GATK

REFERENCE=../../download/refs/canFam3.fa

Chrom=chr$SGE_TASK_ID
OutDir=$1

# Uncomment the line below and fill in the name of the individuals.
# individuals_array = ( ) 

java -jar -Xmx16G ${GATK} \
-T GenotypeGVCFs \
-R ${REFERENCE} \
-allSites \
-stand_call_conf 0 \
-L ${Chrom} \
$(for Individual in "${AllIndividuals[@]}"; do echo "-V ../../analyses/step8_GATKHG/${Individual}/${Individual}_${Chrom}_GATK_HC.g.vcf.gz"; done) \
-o ${OutDir}/5GS_5TM_joint_${Chrom}.vcf.gz
