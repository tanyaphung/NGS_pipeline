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
* Suggested memory requested per sample: 4GB
* Suggested time requested per sample: 5 hours

# Step 2: Convert reads to unmapped bam
* Working directory is `scripts/step2_FastqToSam`
* Use Picard FastqToSam to convert fastq reads to unmapped bam. Script used is `step2_FastqToSam.sh`. Usage is:
```
./step2_FastqToSam.sh individual_name /path/to/Fastq/directory/ /path/to/outBam/directory/
```
* See the wrapper script `wrapper_step2_FastqToSam.sh` for how to automate to multiple samples. 
* Suggested memory requested per sample: 8GB
* Suggested time requested per sample: 10 hours
