# Base image with CUDA support
FROM nvidia/cuda:12.4.0-base-ubuntu22.04

# Set environment variables
ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all"

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    ffmpeg \
    git \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Create and set up persistent directories with proper permissions
RUN mkdir -p /app/static /app/models /app/voice_memories /app/voice_references \
    /app/voice_profiles /app/cloned_voices /app/audio_cache /app/tokenizers /app/logs && \
    chmod -R 777 /app/voice_references /app/voice_profiles /app/voice_memories \
    /app/cloned_voices /app/audio_cache /app/static /app/logs /app/tokenizers /app/models

# Copy static files
COPY ./static /app/static

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install torch torchaudio numpy

# Install torchao from source
RUN pip3 install git+https://github.com/pytorch/ao.git

# Install torchtune from source with specific branch for latest features
RUN git clone https://github.com/pytorch/torchtune.git /tmp/torchtune && \
    cd /tmp/torchtune && \
    git checkout main && \
    pip install -e .

# Install remaining dependencies
RUN pip3 install -r requirements.txt

# Install additional dependencies for streaming and voice cloning
RUN pip3 install yt-dlp openai-whisper

# Copy application code
COPY ./app /app/app

# Show available models in torchtune (for debug/log)
RUN python3 -c "import torchtune.models; print('Available models in torchtune:', dir(torchtune.models))"

# Expose port
EXPOSE 8000

# Command to run the application
CMD ["python3", "-m", "app.main"]
