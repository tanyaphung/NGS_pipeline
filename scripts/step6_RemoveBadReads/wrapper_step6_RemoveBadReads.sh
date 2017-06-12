#!/bin/bash

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

# Uncomment the line below and fill in the name of the individuals.
# individuals_array = ( )

for i in "${individuals_array[@]}"
do

$QSUB -N ${i}RemoveBadReads step6_RemoveBadReads.sh ${i} ../../analyses/step5_MarkDups ../../analyses/step6_RemoveBadReads
sleep 2h

done
