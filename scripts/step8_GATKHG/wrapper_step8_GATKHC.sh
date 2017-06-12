#!/bin/bash

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

# Uncomment the line below and fill in the name of the individuals.
# individuals_array = ( )

for i in "${individuals_array[@]}"
do

$QSUB -N ${i}.step8.A -t 1-38:1 step8_GATKHC_A.sh ${i} ../../analyses/step7_BQSR ../../analyses/step8_GATKHG

$QSUB -N ${i}.step8.X step8_GATKHC_X.sh ${i} ../../analyses/step7_BQSR ../../analyses/step8_GATKHG

done

