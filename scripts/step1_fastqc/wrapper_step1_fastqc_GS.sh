#!/bin/bash
#$ -cwd
#$ -V
#$ -N step2_fastqc_GS
#$ -l h_data=4G,time=24:00:00
#$ -M eplau
#$ -m ea

QSUB=/u/systems/UGE8.0.1vm/bin/lx-amd64/qsub

$QSUB -N GS1 step1_fastqc.sh GS1
sleep 10m
$QSUB -N GS2 step1_fastqc.sh GS2
sleep 10m
$QSUB -N GS3 step1_fastqc.sh GS3
sleep 10m
$QSUB -N GS4 step1_fastqc.sh GS4
sleep 10m
$QSUB -N GS5 step1_fastqc.sh GS5
