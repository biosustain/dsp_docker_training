Author: Sebastian Schulz
Date: 23 March 2025

### File description

Please see this GitHub issue for details on original input files and procedures to modify them: https://github.com/nf-core/rnaseq/issues/1512.

Files were downloaded and modified as detailed in above GitHub issue.


## Original files (downloaded from ftp)

# Genome sequence fasta 
GCF_000005845.2_ASM584v2_genomic.fna

# Genome annotation gtf (line count: 18024)
GCF_000005845.2_ASM584v2_genomic.gtf


## Modified files

# Modified gtf (all empty transcript fields removed -> line count: 13385)
GCF_000005845.2_ASM584v2_genomic_modified.gtf

# Self-generated transcript fasta and genome index (both are outputs from gffread)
GCF_000005845.2_ASM584v2_modified_transcript.fna
GCF_000005845.2_ASM584v2_genomic.fna.fai