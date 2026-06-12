FROM ubuntu:latest

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar herramientas de compilación nativas y dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libc6-dev \
    gdb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
