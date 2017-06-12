#!/bin/bash

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

# Uncomment the line below and fill in the name of the individuals.
# individuals_array = ( )

for i in "${individuals_array[@]}"
do

$QSUB -N ${i}.step7b.R1 step7b_BQSRBaseRecalibrator_round1.sh ${i} ../../analyses/step6_RemoveBadReads ../../analyses/step7_BQSR round1

sleep 30m

done
