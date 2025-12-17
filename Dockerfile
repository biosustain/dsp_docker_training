# Base image
FROM debian:13

# Define working directory
WORKDIR /app

# Installing the required software
RUN apt-get update && apt-get -y install \
    bowtie2 \
    curl \
    samtools

# Downloading and installing featureCOunts
RUN curl -L -o subread-2.0.8-Linux-x86_64.tar.gz \
https://sourceforge.net/projects/subread/files/subread-2.0.8/subread-2.0.8-Linux-x86_64.tar.gz/download

#Uncompressing and removing the compressed file
RUN tar -xzf subread-2.0.8-Linux-x86_64.tar.gz && \
    rm subread-2.0.8-Linux-x86_64.tar.gz

# Specifying the path to featureCounts executable
ENV PATH="${PATH}:/app/subread-2.0.8-Linux-x86_64/bin/"

# Copying our script in. the container
COPY scripts/ ./scripts

# If you want to execute the script by default use CMD ["./scripts/align_and_count_prok.sh"]