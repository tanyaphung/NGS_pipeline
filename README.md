# Pipeline for next generation sequencing analysis
I describe here the pipeline I used to process whole genome sequencing reads. This pipeline goes from fastq reads downloaded from Sequence Read Archive (SRA) and ends with variants in VCF (Variant Calling Format) files. 

Credit: The pipeline and scripts were modified from work by Jacqueline Robinson (UCLA). We followed GATK's best practices.

# Setting up a conda environment
```
conda create --name NGSProcess python=2.7 fastqc bwa samtools picard gatk
```

* Note that for GATK you will have to download the `GenomeAnalysisTK.jar` file and follow the instruction.

* Prior to running any scripts, do:
```
source activate NGSProcess
```

* The environment can be deactivated with:
```
source deactivate
```

* If you don't know how to setting up a conda environemnt, this tutorial here would be helpful: https://github.com/thw17/BIO598_Tutorial

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

# Step 8: Generate gVCF file for each individual:
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
* Working directory is `scripts/step10_obtain_high_qual_sites`

### Step 1: extract DP for each site because I will use the DP information to determine whether a site is high quality or note.
* working directory is `scripts/step10_obtain_high_qual_sites/extract_DP`
* To extracct the DP (depth) for each site, use script `extract_DP.py`. Usage is:
```
python extract_DP.py -h                                                     
usage: extract_DP.py [-h] --VCF VCF --outfile OUTFILE

This script takes in a VCF files before any filtering on variants is done. The
input VCF should contain all the sites (both variants and nonvariants). This
script outputs the value of DP for each sites.

optional arguments:
  -h, --help         show this help message and exit
  --VCF VCF          REQUIRED. Path to the VCF file. Should be gzipped.
  --outfile OUTFILE  REQUIRED. Path to the output file.
```
* The idea is that I want to keep only the sites where the DP is within 50% or 150% of the mean AND there is no mising information for all individuals (AN is equal to 2 times the number of individuals in your particular study). So after extracting out the DP information for each site, the next step is to compute the mean across the whole genome

* Use the R script `compute_DP_sum.R`. Usage is:
```
Rscript compute_DP_sum.R /path/to/DP/data/ /which/chromosome/ /path/to/output/file/
```
### Step 2: Use GATK VariantFiltration to mark the sites based on poor AN or DP
* Working directory is `scripts/step10_obtain_high_qual_sites/obtain_high_quality_sites`
* Use the script `obtain_high_quality_sites.sh`
* Note: (1) Before using this script, on line 19, please put in the correct value for AN. For example, if you have 10 individuals in your samples, you should put 20. This is probably a strict cutoff. If you have a lot of individuals, it will be harder for the site to be called for every individual. Therefore, please adjust this value accordingly. (2) On line 20, please put in the correct value for DP cutoff. You should be able to obtain the mean of DP across all sites and compute the percentage cutoff that is appropriate for your particular study. 
* See the wrapper script `wrapper_obtain_high_quality_sites.sh`

### Step 3: Extract out high quality coordinates
* Working directory is `scripts/step10_obtain_high_qual_sites/obtain_high_quality_coordinates`
* GATK VariantFiltration annotates the variants that do not have information on DP or AN as pass. However, I do not want the variants with missing information. Therefore, I wrote a custom Python script to obtain only the coordinates (positions) where the AN and DP conditions are met and that there are no missing data.
* Use the script `obtain_high_qual_coordinates.py`. Usage is:
```
python obtain_high_qual_coordinates.py -h              [ 4:54PM]
usage: obtain_high_qual_coordinates.py [-h] --VCF VCF --outfile OUTFILE

This script takes in a VCF after step10_obtain_high_qual_sites and returns a
list of coordinates that is high quality. The reason for this extra script is
that GATK variant filtration will annotate a site as PASS when there is no
information in the INFO column. When there is no information in the INFO
column, it is simply a dot.

optional arguments:
  -h, --help         show this help message and exit
  --VCF VCF          REQUIRED. VCF file. Should be gzipped
  --outfile OUTFILE  REQUIRED. Name of output file. End of .bed. Note that
                     this bed file is 0-based.
```

* Because the output bed file is for each site, merging is necessary. Use the script `merge_high_qual_coordinates.sh`. Note: fill in the path to input and output files. 

### Step 4: Remove the poor quality sites from VCF
* Working directory is `scripts/step10_obtain_high_qual_sites/retain_from_VCF_high_qual_sites`
* Use the script `retain_from_VCF_high_qual_sites.sh`. Usage is:
```
./retain_from_VCF_high_qual_sites.sh what_chromosome /path/to/input/VCF/file/ /path/to/output/VCF/file/ /path/to/bed/file/
```

# Step 11: Filter variants 

* Because I am dealing with non-model species (non-human), I will use GATK hard filters to filter my variants
* Working directory is `scripts/step11_filter_high_qual_variants/`.
* Use script `step11_HardFilter.sh`
* See wrapper script `wrapper_step11_HardFilter.sh`.



