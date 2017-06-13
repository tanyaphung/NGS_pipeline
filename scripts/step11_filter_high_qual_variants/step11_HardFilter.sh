#!/bin/bash

. /u/local/Modules/default/init/modules.sh
module load java/1.8.0_77

GATK="" # Please input the path to GATK here
REFERENCE=../../download/refs/canFam3.fa

Chrom=chr$1
inDir=$2
outDir=$3


MEM=4G

############################################
### Select variants by excluding nonvariants
############################################


java -Xmx$MEM -jar ${GATK} \
        -R ${REFERENCE} \
	-T SelectVariants \
	--excludeNonVariants \
	-V ${inDir}/5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz \
	-o ${outDir}/${Chrom}/1_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz

###############
### Hard filter
###############

java -Xmx$MEM -jar ${GATK} \
        -R ${REFERENCE} \
        -T VariantFiltration \
        -V ${outDir}/${Chrom}/1_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz \
        -filter "QD < 2.0" -filterName "lowQD" \
	-filter "FS > 60.0" -filterName "highFS" \
	-filter "MQ < 40.0" -filterName "lowMQ" \
	-filter "MQRankSum < -12.5" -filterName "lowMQRankSum" \
	-filter "ReadPosRankSum < -8.0" -filterName "lowReadPosRankSum" \
        -o ${outDir}/${Chrom}/2_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz

###################################################################################################
###### Select variants
###### The goal of this intermediate file is to quickly check whether GATK is doing the right thing
###################################################################################################

java -Xmx$MEM -jar ${GATK} \
        -R ${REFERENCE} \
        -T SelectVariants \
        -V ${outDir}/${Chrom}/2_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz \
        -ef \
        -o ${outDir}/${Chrom}/3_SV_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz


###################################################
###### Select variants
###### Select biallelic SNP
###### Only retain sites that are annotated as PASS
###################################################

java -Xmx$MEM -jar ${GATK} \
        -R ${REFERENCE} \
        -T SelectVariants \
        -V ${outDir}/${Chrom}/3_SV_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz \
        -selectType SNP \
        --restrictAllelesTo BIALLELIC \
        -o ${outDir}/${Chrom}/4_BiSNP_SV_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz


##################################################
###### Remove clustered SNPs (> 3SNPs within 10bp)
##################################################

java -Xmx$MEM -jar ${GATK} \
        -R ${REFERENCE} \
        -T VariantFiltration \
        -V ${outDir}/${Chrom}/4_BiSNP_SV_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz \
        --clusterWindowSize 10 --clusterSize 3 \
        -o ${outDir}/${Chrom}/5_rmClusterSNP_BiSNP_SV_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz

########################
###### Retain PASS sites
########################

java -Xmx$MEM -jar ${GATK} \
        -R ${REFERENCE} \
        -T SelectVariants \
        -V ${outDir}/${Chrom}/5_rmClusterSNP_BiSNP_SV_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz \
        -ef \
        -o ${outDir}/${Chrom}/6_SV_rmClusterSNP_BiSNP_SV_HardFilter_SV_5GS_5TM_joint_${Chrom}_HighQualSites_processed.vcf.gz
