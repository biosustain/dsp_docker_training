#!/bin/bash
# Author: Juliana Assis - nf-core-hackathon 2025
# Adapted by Albert Palleja for the Docker course - 2025-11-26
# Salmon version (nf-core/rnaseq-like prokaryotic mode) for the Docker course - 2026-11-18

# In this script we want to quantify the reads from a subsampled Escherichia coli sample against the
# E. coli K-12 transcriptome and count the reads per gene.
# For this purpose we follow the same steps that nf-core/rnaseq uses for prokaryotic genomes with Salmon:
#   1. Remove the GTF lines with an empty transcript_id (the "gene" lines in NCBI prokaryotic GTFs)
#   2. Build a transcriptome fasta from the genome + filtered GTF with gffread
#   3. Build a decoy-aware Salmon index (transcriptome + genome as decoy)
#   4. Quantify the paired-end reads with Salmon (selective alignment) and summarise counts per gene
# We will run this script inside a docker container built with the Dockerfile in docker_file/Dockerfile_salmon

set -euo pipefail

# Define directories and parameters
REF_DIR="/app/reference"                                          # Directory for files derived from the reference
SALMON_INDEX="${REF_DIR}/salmon_index"                            # Directory with the Salmon index
GTF_FILE="/app/data/GCF_000005845.2_ASM584v2_genomic.gtf"         # GTF annotation file
GENOME_FASTA="/app/data/GCF_000005845.2_ASM584v2_genomic.fna"     # Genome fasta file
FILTERED_GTF="${REF_DIR}/genomic_filtered.gtf"                    # GTF without empty transcript_id lines
TRANSCRIPT_FASTA="${REF_DIR}/transcripts.fa"                      # Transcript (CDS/ncRNA) sequences
TX2GENE="${REF_DIR}/tx2gene.tsv"                                  # Transcript-to-gene table
READ1="/app/data/SRR9681150_1_sub_50k.fastq.gz"                   # Forward reads
READ2="/app/data/SRR9681150_2_sub_50k.fastq.gz"                   # Reverse reads
RESULTS="/app/results"                                            # Output directory
THREADS=4                                                         # Number of cpus to use

# Create directories if they don't exist
mkdir -p "$REF_DIR"
mkdir -p "$RESULTS"

# Step 1: Prokaryotic mode - remove GTF lines with an empty transcript_id
# NCBI prokaryotic GTFs contain "gene" lines with transcript_id "" that break transcriptome generation
grep -v 'transcript_id ""' "$GTF_FILE" > "$FILTERED_GTF"

# Step 2: Build the transcriptome fasta (one sequence per transcript) from the genome and the filtered GTF
# The genome is copied first because /app/data is mounted read-only and gffread writes a .fai index next to it
# --table writes a transcript-to-gene table (same transcript names as in the fasta),
# so Salmon can also report counts per gene
cp "$GENOME_FASTA" "${REF_DIR}/genome.fna"
gffread "$FILTERED_GTF" \
	-g "${REF_DIR}/genome.fna" \
	-w "$TRANSCRIPT_FASTA" \
	--table @id,@geneid \
	-o "$TX2GENE"

# Step 3: Build a decoy-aware Salmon index (only required once)
# The genome is appended to the transcriptome as a decoy, so reads coming from non-annotated regions
# are not wrongly assigned to transcripts
grep '^>' "${REF_DIR}/genome.fna" | cut -d ' ' -f 1 | sed 's/^>//' > "${REF_DIR}/decoys.txt"
cat "$TRANSCRIPT_FASTA" "${REF_DIR}/genome.fna" > "${REF_DIR}/gentrome.fa"
salmon index \
	-t "${REF_DIR}/gentrome.fa" \
	-d "${REF_DIR}/decoys.txt" \
	-i "$SALMON_INDEX" \
	-p "$THREADS"

# Step 4: Quantify the reads with Salmon
# -l A: automatically detect the library type (strandedness)
# -g: summarise transcript-level estimates to gene level (quant.genes.sf)
salmon quant \
	-i "$SALMON_INDEX" \
	-l A \
	-1 "$READ1" \
	-2 "$READ2" \
	-g "$TX2GENE" \
	--validateMappings \
	-p "$THREADS" \
	-o "${RESULTS}/salmon_quant"
