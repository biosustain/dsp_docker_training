# Execute this script to download fastq.gz files for a single E. coli sample (paired-end)
# 1 GB per file (download takes about 15 mins but this depends on the internet connection)
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR968/000/SRR9681150/SRR9681150_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR968/000/SRR9681150/SRR9681150_2.fastq.gz
