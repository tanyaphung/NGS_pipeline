#!/bin/bash

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

# Uncomment the line below and fill in the name of the individuals.
# individuals_array = ( ) 
for i in "${individuals_array[@]}"
do

$QSUB -N ${i}FastqToSam step2_FastqToSam.sh ${i} ../../download/fastq ../../analyses/step2_FastqToSam
sleep 10m

done
