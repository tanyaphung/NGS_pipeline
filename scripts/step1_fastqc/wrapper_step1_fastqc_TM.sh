#!/bin/bash
#$ -cwd
#$ -V
#$ -N step1_fastqc_TM
#$ -l h_data=4G,time=24:00:00
#$ -M eplau
#$ -m ea

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

$QSUB -N TM1 step1_fastqc.sh TM1
sleep 10m
$QSUB -N TM2 step1_fastqc.sh TM2
sleep 10m
$QSUB -N TM3 step1_fastqc.sh TM3
sleep 10m
$QSUB -N TM4 step1_fastqc.sh TM4
sleep 10m
$QSUB -N TM5 step1_fastqc.sh TM5
