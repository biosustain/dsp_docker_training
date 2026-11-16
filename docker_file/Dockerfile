FROM debian:13

LABEL image.description="A docker image for aligning prokaryotic RNA-seq data with bowtie2 and counting reads with Salmon"
LABEL image.author.name="Albert Palleja"

WORKDIR /app

RUN apt-get update && apt-get -y install \
    bowtie2 \
    gffread \
    salmon \
    samtools && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/ ./scripts/

