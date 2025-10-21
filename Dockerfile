# syntax=docker/dockerfile:1
# CUDA 12 runtime on Ubuntu 22.04
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1

# Minimal Python + pip
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd -ms /bin/bash app
USER app
WORKDIR /app

# Copy repo (current directory) into the image
COPY --chown=app:app . /app

# Upgrade pip and install boltz with CUDA extra
RUN python3 -m pip install --upgrade pip && \
    pip install "boltz[cuda]" -U

# Default command: quick sanity print (override as needed)
CMD ["python3", "-c", "import boltz; print('boltz', boltz.__version__)"]
