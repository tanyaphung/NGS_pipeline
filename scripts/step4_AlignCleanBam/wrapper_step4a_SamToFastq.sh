#!/bin/bash
QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

# Uncomment the line below and fill in the name of the individuals.
# individuals_array = ( )

for i in "${individuals_array[@]}"
do

$QSUB -N ${i}SamToFastq step4a_SamToFastq.sh ${i} ../../analyses/step3_MarkAdapters ../../analyses/step4_AlignCleanBam
sleep 10m

done
