FROM python:3.13

WORKDIR /app

# STAR
ADD https://github.com/alexdobin/STAR/releases/download/2.7.11b/STAR_2.7.11b.zip ./

# subread
ADD https://sourceforge.net/projects/subread/files/subread-2.0.8/subread-2.0.8-Linux-x86_64.tar.gz/download ./
RUN mv download subread-2.0.8-Linux-x86_64.tar.gz

RUN unzip STAR_2.7.11b.zip && \
    tar -xzf subread-2.0.8-Linux-x86_64.tar.gz && \
    rm STAR_2.7.11b.zip \
        subread-2.0.8-Linux-x86_64.tar.gz

RUN apt-get update && apt-get -y install bowtie bowtie2 salmon samtools

ENV PATH="${PATH}:/app/STAR_2.7.11b/Linux_x86_64_static:/app/subread-2.0.8-Linux-x86_64/bin/"

COPY scripts/ ./scripts/

