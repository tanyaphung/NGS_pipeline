#!/bin/bash

Individual=$1

fastqc -o ../../analyses/step1_fastqc ../../download/fastq/${Individual}/*.fastq.gz
