#!/usr/bin/env python3
"""
generate_hero_video.py — Cinematic Website Builder hero video generator
Uses Veo 3.1 via GOOGLE_API_KEY to animate a reference image into an 8s video.

Usage:
    python3 generate_hero_video.py <image_path> <output_video_path> "<animation_prompt>"

Requires:
    GOOGLE_API_KEY environment variable (from docker container's system_config.sh)
    google-genai Python package: pip install google-genai
"""
import os
import sys
import time

def generate_video(image_path: str, output_path: str, prompt: str) -> bool:
    try:
        from google import genai
        from google.genai import types
    except ImportError:
        print("ERROR: google-genai not installed. Run: pip install google-genai")
        return False

    api_key = os.environ.get("GOOGLE_API_KEY")
    if not api_key:
        print("ERROR: GOOGLE_API_KEY not set")
        return False

    client = genai.Client(api_key=api_key)

    with open(image_path, 'rb') as f:
        img_bytes = f.read()

    print(f"Generating video from {image_path}...")
    print(f"Prompt: {prompt}")

    operation = client.models.generate_videos(
        model='veo-3.1-generate-preview',
        image=types.Image(image_bytes=img_bytes, mime_type='image/png'),
        config=types.GenerateVideosConfig(
            person_generation='allow_all',
            aspect_ratio='16:9'
        ),
        prompt=prompt
    )

    print("Waiting for video generation to complete...")
    while not operation.done:
        time.sleep(10)
        print(f"  ... still processing ({operation.metadata.get('progress', 'n/a')})")

    if operation.error:
        print(f"ERROR: {operation.error}")
        return False

    video = operation.result
    video_bytes = video.generated_video_bytes

    with open(output_path, 'wb') as f:
        f.write(video_bytes)

    print(f"SUCCESS: Video saved to {output_path} ({len(video_bytes)} bytes)")
    return True

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Usage: python3 generate_hero_video.py <image_path> <output_path> <prompt>")
        sys.exit(1)

    image_path = sys.argv[1]
    output_path = sys.argv[2]
    prompt = sys.argv[3]

    success = generate_video(image_path, output_path, prompt)
    sys.exit(0 if success else 1)
