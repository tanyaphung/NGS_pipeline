#!/bin/bash

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

$QSUB -N step9.A -t 1-38:1 step9_GenotypeGVCFs_A.sh ../../analyses/step9_GenotypeGVCFs

$QSUB -N step9.X step9_GenotypeGVCFs_X.sh ../../analyses/step9_GenotypeGVCFs
