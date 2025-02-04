# Use Ubuntu as a parent image
FROM ubuntu:20.04

# Install Docker dependencies (optional, if not using features)
RUN apt-get update && apt-get install -y \
  docker.io \
  docker-compose

# Expose the Docker socket
RUN groupadd docker && usermod -aG docker $USER
