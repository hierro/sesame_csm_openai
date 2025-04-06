# CSM-1B TTS API - Usage Guide

This document contains detailed usage examples and API instructions based on the original implementation by [@phildougherty](https://github.com/phildougherty). These examples are fully compatible with the containerized version provided in this repository.

For full documentation and development setup instructions, see the main [README](./README.md).

---

## Text-to-Speech (Standard Usage)

Generate speech from text using the OpenAI-compatible endpoint:

```bash
curl -X POST http://localhost:8000/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{
    "model": "csm-1b",
    "input": "Hello, this is a test of the CSM text to speech system.",
    "voice": "alloy",
    "response_format": "mp3"
  }' \
  --output speech.mp3
```

> Tip: You can change the format to `wav`, `flac`, or others (see below).

---

## Voice Cloning via Web Interface

Open in your browser:

```
http://localhost:8000/voice-cloning
```

Then:
1. Go to the "Clone Voice" tab
2. Upload a sample (2–3 minutes recommended)
3. Name the voice and optionally add a transcript
4. Generate and preview the voice in "My Voices"

> Tip: You can paste a YouTube link instead of uploading a file to auto-extract voice.

---

## Voice Cloning via API

### Clone a Voice

```bash
curl -X POST http://localhost:8000/v1/voice-cloning/clone \
  -F "name=My Voice" \
  -F "audio_file=@/path/to/voice.mp3" \
  -F "transcript=Optional transcript" \
  -F "description=Cloned from my voice"
```

### List Cloned Voices

```bash
curl -X GET http://localhost:8000/v1/voice-cloning/voices
```

### Generate Speech with Cloned Voice

```bash
curl -X POST http://localhost:8000/v1/voice-cloning/generate \
  -H "Content-Type: application/json" \
  -d '{
    "voice_id": "1234567890_my_voice",
    "text": "This is my cloned voice speaking.",
    "temperature": 0.7
  }' \
  --output cloned_speech.mp3
```

### Preview a Voice

```bash
curl -X POST http://localhost:8000/v1/voice-cloning/voices/1234567890_my_voice/preview \
  --output preview.mp3
```

### Delete a Voice

```bash
curl -X DELETE http://localhost:8000/v1/voice-cloning/voices/1234567890_my_voice
```

---

## Clone Voice from YouTube

POST request:

```json
{
  "youtube_url": "https://youtube.com/watch?v=xxxxx",
  "voice_name": "youtuber_voice",
  "start_time": 30,
  "duration": 60,
  "description": "Voice from YouTube"
}
```

Response:

```json
{
  "voice_id": "1710805983_youtuber_voice",
  "name": "youtuber_voice",
  "description": "Voice from YouTube",
  "audio_duration": 60.0
}
```

> Tip: Use start time + duration to extract the best speech segments.

---

## Voice Cloning Tips

- Use 2–3 minutes of clean, high-quality audio
- Record in a quiet room without music or effects
- Provide transcript for better alignment
- Lower temperature for stable voice identity
- Retry cloning with different samples for better results

---

## Available Voices

Built-in voices:

- `alloy` - Balanced and natural
- `echo` - Resonant
- `fable` - Bright and higher-pitched
- `onyx` - Deep and resonant
- `nova` - Warm and smooth
- `shimmer` - Light and airy

Your cloned voices will also be listed in `/v1/audio/voices`

---

## Supported Output Formats

- `mp3`
- `opus`
- `aac`
- `flac`
- `wav`

---

## Integration: OpenWebUI

To use with [OpenWebUI](https://github.com/open-webui/open-webui):

1. Open TTS settings
2. Choose **Custom TTS Endpoint**
3. URL: `http://localhost:8000/v1/audio/speech`

Cloned voices appear automatically in the selector.

---

## Advanced API – Conversational Context

Send prior utterances to improve realism:

```bash
curl -X POST http://localhost:8000/api/v1/audio/conversation \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Nice to meet you too!",
    "speaker_id": 0,
    "context": [
      {
        "speaker": 1,
        "text": "Hello, nice to meet you.",
        "audio": "BASE64_ENCODED_AUDIO"
      }
    ]
  }' \
  --output reply.wav
```

> Tip: Use this for call-and-response scenarios or emotional continuity.

---

## Troubleshooting

### Model not loading / 503 errors?

- Ensure `.env` is present and `HF_TOKEN` is correct
- Accept model license at: https://huggingface.co/sesame/csm-1b
- Inspect logs via VS Code terminal (or `docker logs`)

### Audio too short or cuts off?

- Try shorter inputs
- Use `.wav` format for best quality
- Adjust: `temperature`, `speed`, `max_audio_length_ms`

### Voice clone quality issues?

- Ensure clean audio (no background music)
- Retry with transcript and without
- Use samples with natural, expressive tone

---

## License and Credits

MIT License — This repo is a containerized fork of [@phildougherty](https://github.com/phildougherty)'s project.

Model by [Sesame](https://www.sesame.com). Fork maintained at [github.com/hierro/sesame_csm_openai](https://github.com/hierro/sesame_csm_openai).

