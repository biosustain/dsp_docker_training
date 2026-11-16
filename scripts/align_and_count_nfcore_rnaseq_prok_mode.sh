#!/bin/bash
# Author: Juliana Assis - nf-core-hackathon 2025
# Adapted by Albert Palleja for the Docker course - 2025-11-26
# Salmon version (like the nf-core/rnaseq "bowtie2_salmon" prokaryotic mode) for the Docker course - 2026-11-18

# In this script we want to align the reads from a subsampled Escherichia coli sample to the E. coli K-12
# transcriptome (the sequences of its genes) and count the reads per transcript and per gene.
# For this purpose we are going to use bowtie2 for the alignment and Salmon for the read counting
# We will run this script inside a docker container built with the Dockerfile in docker_file/Dockerfile_salmon

set -euo pipefail

# Define directories and parameters
REF_DIR="/app/reference"                                          # Directory for files derived from the reference
GENOME_DIR="${REF_DIR}/bowtie2_index"                             # Bowtie2 transcriptome index (prefix)
GTF_FILE="/app/data/GCF_000005845.2_ASM584v2_genomic.gtf"         # GTF annotation file
GENOME_FASTA="/app/data/GCF_000005845.2_ASM584v2_genomic.fna"     # Genome fasta file
FILTERED_GTF="${REF_DIR}/genomic_filtered.gtf"                    # GTF without empty transcript_id lines
TRANSCRIPT_FASTA="${REF_DIR}/transcripts.fa"                      # Transcript sequences (index generation and Salmon)
TX2GENE="${REF_DIR}/tx2gene.tsv"                                  # Transcript-to-gene table
READ1="/app/data/SRR9681150_1_sub_50k.fastq.gz"                   # Forward reads
READ2="/app/data/SRR9681150_2_sub_50k.fastq.gz"                   # Reverse reads
RESULTS="/app/results"                                            # Output directory
THREADS=4                                                         # Number of cpus to use

# Create directories if they don't exist
mkdir -p "$REF_DIR"
mkdir -p "$RESULTS"

# Step 0: Prepare the transcriptome (prokaryotic mode)
# Salmon counts reads per transcript, so the reads must be aligned to the transcript sequences, not to the genome.
# NCBI prokaryotic GTFs contain "gene" lines with transcript_id "" that break transcriptome generation: remove them
grep -v 'transcript_id ""' "$GTF_FILE" > "$FILTERED_GTF"
# gffread builds one sequence per transcript from the genome and the filtered GTF.
# The genome is copied first because /app/data is mounted read-only and gffread writes a .fai index next to it.
# --table writes a transcript-to-gene table, so Salmon can also report counts per gene
cp "$GENOME_FASTA" "${REF_DIR}/genome.fna"
gffread "$FILTERED_GTF" \
	-g "${REF_DIR}/genome.fna" \
	-w "$TRANSCRIPT_FASTA" \
	--table @id,@geneid \
	-o "$TX2GENE"

# Step 1: Generate bowtie index (only required once)
bowtie2-build --threads $THREADS "$TRANSCRIPT_FASTA" "$GENOME_DIR"

# Step 2: Run bowtie2 alignment and sort the output BAM file
# -k 200: report up to 200 alignments per read, so Salmon can share reads that match several transcripts
# The unsorted BAM is kept for Salmon, which needs the alignments of each read next to each other
bowtie2 -x "$GENOME_DIR" \
	-1 "$READ1" \
	-2 "$READ2" \
	-p $THREADS \
	-k 200 \
	--no-unal \
	--no-mixed \
	--no-discordant | \
	samtools view -b -F 4 -o "${RESULTS}/aligned.bam"
samtools sort -@ $THREADS -o "${RESULTS}/aligned_sorted.bam" "${RESULTS}/aligned.bam"

# Step 3: Index the sorted BAM file: enables fast random access to specific regions of the data
samtools index "${RESULTS}/aligned_sorted.bam"

# Step 4: Run Salmon to count reads per transcript and gene
# -l A: automatically detect the library type
# -g: summarise transcript counts to gene level (quant.genes.sf)
salmon quant \
	-t "$TRANSCRIPT_FASTA" \
	-l A \
	-a "${RESULTS}/aligned.bam" \
	-g "$TX2GENE" \
	-p $THREADS \
	-o "${RESULTS}/salmon_quant"
