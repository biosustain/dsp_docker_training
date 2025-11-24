FROM debian:13

LABEL image.author.name="Albert Palleja"
LABEL image.author.email="apca@dtu.dk"

WORKDIR /app

RUN apt-get update && apt-get -y install \
    bowtie2 \
    curl \
    samtools

# subread
# ADD https://sourceforge.net/projects/subread/files/subread-2.0.8/subread-2.0.8-Linux-x86_64.tar.gz/download ./
# RUN mv download subread-2.0.8-Linux-x86_64.tar.gz
RUN curl -L -o subread-2.0.8-Linux-x86_64.tar.gz https://sourceforge.net/projects/subread/files/subread-2.0.8/subread-2.0.8-Linux-x86_64.tar.gz/download

RUN tar -xzf subread-2.0.8-Linux-x86_64.tar.gz && \
    rm subread-2.0.8-Linux-x86_64.tar.gz

ENV PATH="${PATH}:/app/subread-2.0.8-Linux-x86_64/bin/"

COPY scripts/ ./scripts/

