#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_data=4G,time=24:00:00
#$ -M eplau
#$ -m ea

individual=$1

fastqc -o ../../analyses/step1_fastqc/${individual} ../../download/fastq/${individual}/*.fastq.gz
