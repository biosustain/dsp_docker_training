FROM python:3.13

LABEL image.author.name="Albert Palleja"
LABEL image.author.email="apca@dtu.dk"

WORKDIR /app

# subread
ADD https://sourceforge.net/projects/subread/files/subread-2.0.8/subread-2.0.8-Linux-x86_64.tar.gz/download ./
RUN mv download subread-2.0.8-Linux-x86_64.tar.gz

RUN tar -xzf subread-2.0.8-Linux-x86_64.tar.gz && \
    rm subread-2.0.8-Linux-x86_64.tar.gz

RUN apt-get update && apt-get -y install bowtie2 samtools

ENV PATH="${PATH}:/app/STAR_2.7.11b/Linux_x86_64_static:/app/subread-2.0.8-Linux-x86_64/bin/"

COPY scripts/ ./scripts/

