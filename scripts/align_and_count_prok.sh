#!/bin/bash

# bowtie2 alignment + featureCounts for prokaryotic bacterial genome
# Working with the original version of the GTF file


# Define input files and parameters
GENOME_DIR="/app/data/bowtie2_index"      # Directory with STAR genome index
GTF_FILE="/app/data/GCF_000005845.2_ASM584v2_genomic.gtf"       # GTF annotation file
GENOME_FASTA="/app/data/GCF_000005845.2_ASM584v2_genomic.fna"     # Genome fasta file for STAR index generation
READ1="/app/data/SRR9681150_1_sub_50k.fastq.gz"           # Forward reads
READ2="/app/data/SRR9681150_2_sub_50k.fastq.gz"           # Reverse reads
RESULTS="/app/results"                # Output directory
THREADS=4

# Create index directory if it doesn't exist
mkdir -p $GENOME_DIR
mkdir -p $RESULTS

# Step 1: Generate bowtie index (only required once)
bowtie2-build $GENOME_FASTA $GENOME_DIR
	
# Step 2: Run bowtie2 alignment

bowtie2 -x $GENOME_DIR \
	-1 $READ1 \
	-2 $READ2 \
	--no-unal \
	--no-mixed \
	--no-discordant | \
	samtools view -b -F 4 | \
	samtools sort -o /app/results/aligned_sorted.bam
 

samtools index /app/results/aligned_sorted.bam #Change or make a folder

# Step 4: Run featureCounts
featureCounts -T $THREADS \
	-p \
    -a $GTF_FILE \
	-o "/app/results/gene_counts.txt" \
    -t CDS \
	-g gene_id \
	--countReadPairs \
	/app/results/aligned_sorted.bam