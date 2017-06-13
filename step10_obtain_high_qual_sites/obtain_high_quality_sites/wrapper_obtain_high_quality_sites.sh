#!/bin/bash

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

i=X
$QSUB -N chr${i}.High.Qual.Sites obtain_high_quality_sites.sh ${i} ../../analyses/step9_GenotypeGVCFs ../../analyses/step10_obtain_high_qual_sites

for i in {1..38}
do

$QSUB -N chr${i}.High.Qual.Sites obtain_high_quality_sites.sh ${i} ../../analyses/step9_GenotypeGVCFs ../../analyses/step10_obtain_high_qual_sites

done
