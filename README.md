CSM-1B TTS API (Containerized Developer Edition)

An enhanced, container-ready version of the original CSM-1B TTS API, designed for local development and deployment using VS Code Dev Containers, Docker Desktop, and NVIDIA GPU acceleration.

This fork preserves all features from the original project while adding:

- Developer-friendly containerization via `.devcontainer/`
- Hot-reload support for code changes
- Safe `.env.template` handling for Hugging Face tokens
- Portable, reproducible setup for local GPU inference
- Delayed model download (at runtime only, not at build-time)

This setup is intended for developers and researchers who want a local, modifiable version of the CSM-1B TTS API with full GPU support.

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

This repository is based on a fork of the open-source implementation by community contributor @phildougherty:

- Original Source: https://github.com/phildougherty/sesame_csm_openai
- Maintained Fork: https://github.com/hierro/sesame_csm_openai

Licensing, acknowledgments, and model terms remain unchanged (MIT License).

---

## Who Is This For?

- Developers working on TTS or AI voice systems
- Researchers exploring voice consistency, cloning, or inference tuning
- Builders of local/private TTS solutions (without cloud dependencies)
- Anyone wanting a reproducible, containerized version of CSM-1B to run locally with NVIDIA GPU acceleration

---

## Prerequisites

- **Host OS**: Windows 10/11 (with WSL2), Linux, or macOS
- **Docker**:
  - Docker Desktop **must be running before you open the project in VS Code**
  - WSL2 backend enabled on Windows
- **GPU Support**:
  - NVIDIA GPU with 8GB+ VRAM (tested with RTX 2080)
  - CUDA 12.8 compatible driver
  - NVIDIA Container Toolkit installed
- **VS Code + Extensions**:
  - Remote - Containers
  - Docker (optional but helpful)

---

## Setup Guide (Using VS Code Dev Containers)

### 1. Clone This Repository
```bash
git clone https://github.com/hierro/sesame_csm_openai.git
cd sesame_csm_openai
```

### 2. Create the `.env` File
```bash
cp .env.template .env
```
Edit `.env` and add your Hugging Face token:
```
HF_TOKEN=your_huggingface_token_here
```
Make sure you’ve accepted model access:
https://huggingface.co/sesame/csm-1b

### 3. Open the Project in VS Code (Containerized)
- Open VS Code.
- Run the command:
```
Dev Containers: Open Folder in Container...
```
- Select the root folder of the cloned repo.

This will:
- Build the container (without downloading the model yet)
- Install Python and system dependencies
- Mount your repo as `/app`
- Enable GPU access via Docker Compose

📌 **Important:** Wait until VS Code finishes installing extensions (e.g. `ms-python.python`) and you see logs like:
```
[Run in container: cat /proc/environ]
```
Then, proceed to the next step.

---

## Running the API

### 4. Launch the Application
Open a **new terminal** inside the container and run:
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

On first run, the model (6GB+) will be downloaded from Hugging Face. This may take 8–10 minutes.

Once complete, you can open:
- Swagger UI: http://localhost:8000/docs
- Voice Cloning UI: http://localhost:8000/voice-cloning

---

## Notes and Recommendations

- Model checkpoint is no longer downloaded during container build. It is now deferred to runtime for efficiency and clarity.
- Audio generation speed and quality depends on GPU and system RAM
- Voice quality improves with usage (voice memory accumulates)
- For better testing, use `.wav` or `.flac` inputs
- You can mount volumes or use bind mounts to persist generated content

---

## What's Included

- `Dockerfile` and `docker-compose.yml` (optimized for GPU)
- `.devcontainer/` folder for VS Code integration
- `.env.template` (configurable)
- Persistent folders: `/models`, `/voice_profiles`, `/voice_memories`, etc.
- `app/` folder with TTS API and Web UI

---

## Acknowledgments

- CSM-1B model by Sesame
- Original implementation: @phildougherty
- Hugging Face model: https://huggingface.co/sesame/csm-1b

> This fork is not affiliated with Sesame or the original authors. It is intended as a developer-friendly variant for easier local testing, modification, and GPU deployment.

---

## Usage and API Reference

See `USAGE.md` for full details on:
- TTS generation (`/v1/audio/speech`)
- Voice cloning (via API or UI)
- YouTube-based voice cloning
- Conversation API support
- OpenWebUI integration
- Advanced options and troubleshooting

