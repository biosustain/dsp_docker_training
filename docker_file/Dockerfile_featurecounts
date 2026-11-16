# Adding a base image
FROM debian:13

# Adding some metadata to the image
LABEL image.description="A docker image for aligning and counting prokaryotic RNA-seq data"
LABEL image.author.name="Albert Palleja"
LABEL image.author.email="apca@dtu.dk"

# Setting the working directory
WORKDIR /app

# Installing required software from apt-get
RUN apt-get update && apt-get -y install \
    bowtie2 \
    curl \
    samtools

# Download feature counts (package called subread)
# ADD https://sourceforge.net/projects/subread/files/subread-2.0.8/subread-2.0.8-Linux-x86_64.tar.gz/download ./
# RUN mv download subread-2.0.8-Linux-x86_64.tar.gz
RUN curl -L -o subread-2.0.8-Linux-x86_64.tar.gz https://sourceforge.net/projects/subread/files/subread-2.0.8/subread-2.0.8-Linux-x86_64.tar.gz/download

# Uncompress and remove the compressed file
RUN tar -xzf subread-2.0.8-Linux-x86_64.tar.gz && \
    rm subread-2.0.8-Linux-x86_64.tar.gz

# Set the path for the featureCounts executable
ENV PATH="${PATH}:/app/subread-2.0.8-Linux-x86_64/bin/"

# Copy an script example to the container
COPY scripts/ ./scripts/

