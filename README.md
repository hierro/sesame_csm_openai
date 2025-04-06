# CSM-1B TTS API (Containerized Developer Edition)

An enhanced, container-ready version of the original [CSM-1B TTS API](https://github.com/phildougherty/sesame_csm_openai), designed for local development and deployment using **VS Code Dev Containers**, **Docker Desktop**, and **NVIDIA GPU acceleration**.

This fork preserves all features from the original project while adding:

- Developer-friendly containerization via `.devcontainer/`
- Hot-reload support for code changes
- Safe `.env.template` handling for Hugging Face tokens
- Portable, reproducible setup for local GPU inference

> This setup is intended for developers and researchers who want a local, modifiable version of the CSM-1B TTS API with full GPU support.

---

## Features

- OpenAI-compatible TTS API (drop-in replacement for OpenAI TTS endpoint)
- 6 high-quality voices with consistent acoustic profiles
- Full voice cloning pipeline via Web UI or API (including YouTube input)
- GPU acceleration via PyTorch + CUDA
- Ready-to-run containerized development setup
- Local-first design with persistent voice and audio cache support

---

## Repository Overview

This repository is based on a fork of the open-source implementation by community contributor [@phildougherty](https://github.com/phildougherty):
- **Original Forked Source**: https://github.com/phildougherty/sesame_csm_openai
- **Current Maintained Fork**: https://github.com/hierro/sesame_csm_openai

All licensing, acknowledgments, and model terms remain unchanged (MIT License).

---

## Who Is This For?

- Developers working on TTS or AI voice systems
- Researchers exploring voice consistency, cloning, or inference tuning
- Builders of local/private TTS solutions (without cloud dependencies)
- Anyone wanting a reproducible, containerized version of CSM-1B to run locally with NVIDIA GPU acceleration

---

## Prerequisites

- **Host OS**: Windows 10/11 or Linux/macOS
- **Docker**: Docker Desktop with WSL2 backend (Windows) or standard Docker engine
- **GPU Support**:
  - NVIDIA GPU with **8GB+ VRAM** (we tested with RTX 2080)
  - CUDA 12.8 compatible driver
  - NVIDIA Container Toolkit installed (required for GPU in Docker)
- **VS Code + Extensions**:
  - [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  - [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) (optional but useful)

---

## Setup Guide (Using VS Code Dev Containers)

### 1. Clone This Repository

```bash
git clone https://github.com/hierro/sesame_csm_openai.git
cd sesame_csm_openai
```

### 2. Create `.env` File

Create a `.env` file in the project root with your Hugging Face token:

```env
HF_TOKEN=your_huggingface_token_here
```

Or copy the template:

```bash
cp .env.template .env
```

Your `.env` file is ignored by Git. Only `.env.template` is committed.

Make sure you have accepted access to the model: https://huggingface.co/sesame/csm-1b

### 3. Open the Project in VS Code (First-Time or Later Use)

When opening the folder in VS Code:

- If prompted, click **"Reopen in Container"**
- Or press **Ctrl+Shift+P** and choose `Dev Containers: Reopen in Container`

This will:
- Build the container from `.devcontainer/`
- Mount your repo as `/app`
- Install dependencies
- Use your `.env` file
- Enable GPU via Docker Compose
- Download the model automatically if not yet present

**Tip**: On first run, model download can take ~8–10 minutes. After that, startup is much faster.

### 4. Verify Setup

Once the container starts, open a terminal and run:

```bash
nvidia-smi            # Should show your GPU
python3 -c "import torch; print(torch.cuda.is_available())"  # Should return True
```

---

## Running the API

In the container terminal:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Then open your browser:

- Swagger API docs: http://localhost:8000/docs
- Voice cloning UI: http://localhost:8000/voice-cloning

> The `/streaming-demo` endpoint requires `static/streaming-demo.html`. If missing, it will return 404.

---

## What’s Included in This Fork

- `Dockerfile` and `docker-compose.yml` for GPU-ready container
- `.devcontainer/` folder for VS Code Dev Containers
- `.env.template` for safe configuration
- Mounts for persistent volumes:
  - `/models`, `/voice_profiles`, `/cloned_voices`, `/voice_memories`, etc.
- Hot reload via `--reload` option in `uvicorn`
- Same API behavior and endpoints as upstream repo

---

## Notes and Recommendations

- Audio generation speed and quality depends on GPU power and system RAM
- Voice quality improves over time as more memory and context accumulate
- Very long sentences may result in truncation or early stopping (tune `max_audio_length_ms`)
- Use WAV or FLAC for better quality during testing

---

## Acknowledgments

- CSM-1B model by [Sesame](https://www.sesame.com/research/crossing_the_uncanny_valley_of_voice)
- Original community implementation by [@phildougherty](https://github.com/phildougherty)
- Hugging Face hosting: https://huggingface.co/sesame/csm-1b

This fork is a developer-focused enhancement — not affiliated with Sesame or the original author.

---

## Usage and API Reference

For full examples, endpoints, parameters, and curl commands, see:

**[USAGE.md](./USAGE.md)** — includes:

- Text-to-speech generation (`/v1/audio/speech`)
- Voice cloning (via Web UI and API)
- YouTube-based cloning
- Available voices and formats
- Conversation API and OpenWebUI integration
- Troubleshooting and advanced usage

This file mirrors the full capabilities from the original repository while integrating with our container-based setup.