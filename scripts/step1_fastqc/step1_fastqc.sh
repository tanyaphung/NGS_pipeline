#!/bin/bash
#$ -cwd
#$ -V
#$ -l h_data=4G,time=24:00:00
#$ -M phung428
#$ -m ea

Individual=$1

fastqc -o ../../analyses/step1_fastqc ../../download/fastq/${Individual}/*.fastq.gz
