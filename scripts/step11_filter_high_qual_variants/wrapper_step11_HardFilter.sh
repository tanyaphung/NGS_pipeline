#!/bin/bash

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

for i in {1..38}
do

$QSUB -N step11.HardFilters.${i} step11_HardFilter.sh ${i} ../../analyses/step10_obtain_high_qual_sites/high_qual_VCFs_processed ../../analyses/step11_filter_high_qual_variants

done

i=X
$QSUB -N step11.HardFilters.${i} step11_HardFilter.sh ${i} ../../analyses/step10_obtain_high_qual_sites/high_qual_VCFs_processed ../../analyses/step11_filter_high_qual_variants
