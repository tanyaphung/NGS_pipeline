# NGS_pipeline
I describe here the pipeline I used to process whole genome sequencing reads. This pipeline goes from fastq reads downloaded from Sequence Read Archive (SRA) and ends with variants in VCF (Variant Calling Format) files. 

Credit: The pipeline and scripts were developed by Jacqueline Robinson (UCLA). I streamlined it here so that it can be easily adapted for analysis of new samples. 

# Setting up a conda environment

# Directory structure
* In all the scripts, I used relative paths instead of absolute path. The reason for this is so that it can be easily modified for subsequent analysis of new samples. 
* In the main directory, I will make 2 directories, `scripts` and `analyses`. The subdirectories under `scripts` and `analyses` are similar:

```
mkdir scripts analyses
cd scripts
mkdir step1_fastqc step2_FastqToSam step3_MarkAdapters step4_AlignCleanBam step5_MarkDups step6_RemoveBadReads step7_BQSR
cd ..
mkdir step1_fastqc step2_FastqToSam step3_MarkAdapters step4_AlignCleanBam step5_MarkDups step6_RemoveBadReads step7_BQSR
```

* Then, within each subdirectory, I make a directory for each sample. For example, my samples' names are: GS1, GS2, GS3, GS4, and GS5. This can be done easily in bash:

```
cd scripts
for dir in */; do                                                            
for i in GS1 GS2 GS3 GS4 GS5; do
mkdir -- "$dir/$i";    
done;
done;
```
* Repeat for the `analysis` directory:

```
cd analyses
for dir in */; do                                                            
for i in GS1 GS2 GS3 GS4 GS5; do
mkdir -- "$dir/$i";    
done;
done;
```
* In the same main directory, I also have a directory called `download`. The subdirectories within `download` is `fastq` and `refs`. I'm not including the content of the `download` directory here because of the size. 

# Step 1: Check raw reads with fastqc
* Working directory is `scripts/step1_fastqc`
* Use the program fastqc to check the raw reads. Script used is `step1_fastqc.sh`. Usage is:
```
./step1_fastqc.sh individual_name
```
* See the wrapper script `wrapper_step1_fastqc.sh` for how to automate to multiple samples.

# Step 2: Convert reads to unmapped bam
* Working directory is `scripts/step2_FastqToSam`
* Use Picard FastqToSam to convert fastq reads to unmapped bam. Script used is `step2_FastqToSam.sh`. Usage is:
```
./step2_FastqToSam.sh individual_name /path/to/Fastq/directory/ /path/to/outBam/directory/
```
* See the wrapper script `wrapper_step2_FastqToSam.sh` for how to automate to multiple samples. 


# Step 3: Mark Illumia adapters
* Working directory is `scripts/step3_MarkAdapters`
* Use Picard MarkIlluminaAdapters to mark illumina adapters. Script used is `step3_MarkAdapters.sh`. Usage is:
```
./step3_MarkAdapters.sh individual_name /path/to/bam/directory/ /path/to/output/directory/
```
* See the wrapper script `wrapper_step3_MarkAdapters.sh` for how to automate to multiple samples

# Step 4: Align clean bam
* Working directory is `scripts/step4_AlignCleanBam`
### Step 4a: Use Picard SamToFastq to convert the clean bam files to fastq files
* Script used is `step4a_SamToFastq.sh`. Usage is:
```
./step4a_SamToFastq.sh individual_name /path/to/input/bam/directory/ /path/to/output/step4/directory/
```
* See wrapper script `wrapper_step4a_SamToFastq.sh`
### Step 4b: Use bwa mem to do the alignment
* Script used is `step4b_BwaMem.sh`. Usage is:
```
./step4b_BwaMem.sh individual_name /path/to/output/step4/directory/
```
* See wrapper script `wrapper_step4b_BwaMem.sh`
### Step 4c: Use Picard MergeBamAlignment
* Script used is `step4c_PicardMergeBamAlignment.sh`. Usage is:
```
./step4c_PicardMergeBamAlignment.sh individual_name /path/to/output/step4/directory/ /path/to/unmapped/bam/directory/ /path/to/output/step4/directory/
```
* See wrapper script `wrapper_step4c_MergeBamAlignment.sh`

# Step 5: Mark duplications
* Working directory is `scripts/step5_MarkDups/`
* Script used is `step5_MarkDups.sh`. Usage is:
```
./step5_MarkDups.sh individual_name /path/to/input/clean/bam/directory/ /path/to/output/step5/directory/
```
* See wrapper script `wrapper_step5_MarkDups.sh`

# Step 6: Remove bad reads
* Working directory is `scripts/step6_RemoveBadReads/`
* Script used is `step6_RemoveBadReads.sh`. Usage is:
```
./step6_RemoveBadReads.sh individual_name /path/to/input/markdups/bam/directory/ /path/to/output/step6/directory/
```
* See wrapper script `wrapper_step6_RemoveBadReads.sh`

# Step 7: GATK Base Quality Score Recalibration (BSQR)
* Working directory is `scripts/step7_BQSR/`
### Step 7a: GATK Unified Genotyper
* Script used is `step7a_BQSRGenotypeCalling_round1.sh`. Usage is:
```
./step7a_BQSRGenotypeCalling_round1.sh individual_name /path/to/input/bam/directory/ /path/to/output/step7/directory/ round_number
```
* See wrapper script `wrapper_step7a_BQSRGenotypeCalling_round1.sh`
### Step 7b: GATK BaseRecalibrator
* Script used is `step7b_BQSRBaseRecalibrator_round1.sh`. Usage is:
```
./step7b_BQSRBaseRecalibrator_round1.sh individual_name /path/to/input/bam/directory/ /path/to/output/step7/directory/ round_number
```
* See wrapper script `wrapper_step7b_BQSRBaseRecalibrator_round1.sh`
### Step 7c: GATK Print Reads
* Script used is `step7c_BQSRPrintReads_round1.sh`. Usage is:
```
./step7c_BQSRPrintReads_round1.sh individual_name /path/to/input/bam/directory/ /path/to/output/step7/directory/ round_number
```
* See wrapper script `wrapper_step7c_BQSRPrintReads_round1.sh`

* Repeat step 7a, 7b, and 7c 3 times (3 rounds). 

# step 8: Generate gVCF file for each individual:
* Working directory is `scripts/step8_GATKHG/`
* Scripts used are `step8_GATKHC_A.sh` and `step8_GATKHC_X.sh`. Usage is:
```
./step8_GATKHC_A.sh individual_name /path/to/bam/directory/ /path/to/output/step8/directory/
./step8_GATKHC_X.sh individual_name /path/to/bam/directory/ /path/to/output/step8/directory/
```
* Note: Before using these scripts, please input the path to GATK.
* See wrapper script `wrapper_step8_GATKHC.sh`

# Step 9: Joint genotyping for all individuals
* Working directory is `scripts/step9_GenotypeGVCFs/`
* Scripts used are `step9_GenotypeGVCFs_A.sh` and `step9_GenotypeGVCFs_X.sh`. Usage is:
```
./step9_GenotypeGVCFs_A.sh /path/to/output/directory/
./step9_GenotypeGVCFs_X.sh /path/to/output/directory/
```
* Note: Before using these scripts, please input the path to GATK and the individual names
* See wrapper script `wrapper_step9_GenotypeGVCFs.sh`

# Step 10: Obtain high quality sites
* For downstream analyses, the invariant sites are needed. These scripts are meant to filter the VCFs such that only high quality sites are kept. 
* 


