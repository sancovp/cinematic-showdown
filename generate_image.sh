#!/bin/bash
# generate_image.sh — Generate images via gpt-image-2 inside mind_of_god docker
# Usage: ./generate_image.sh "<prompt>" <output_path> [size] [quality]
# Example: ./generate_image.sh "A cinematic hero shot" ./hero.png "1536x1024" "low"
#
# Cost: $0.006/image at low quality (1536x1024)

PROMPT="$1"
OUTPUT="$2"
SIZE="${3:-1024x1024}"
QUALITY="${4:-low}"

if [ -z "$PROMPT" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: $0 <prompt> <output_path> [size] [quality]"
    exit 1
fi

# Resolve output to absolute path
case "$OUTPUT" in
    /*) OUTPUT_ABS="$OUTPUT" ;;
    *)  OUTPUT_ABS="$(pwd)/$OUTPUT" ;;
esac

# Write python runner to host temp
cat > /tmp/_gen_runner.py << 'PYEOF'
import os, sys
sys.path.insert(0, "/home/GOD/.pyenv/versions/3.11.6/lib/python3.11/site-packages")
from cave_teams import generate_image
r = generate_image(
    prompt=os.environ["GEN_PROMPT"],
    output_path="/tmp/_gen_out.png",
    size=os.environ.get("GEN_SIZE", "1024x1024"),
    quality=os.environ.get("GEN_QUALITY", "low")
)
print("GENERATED" if r.success else "ERROR:" + str(r.error))
PYEOF

# Copy script into docker container
docker cp /tmp/_gen_runner.py mind_of_god:/tmp/_gen_runner.py

# Run with env vars to avoid quoting hell
GEN_PROMPT="$PROMPT" GEN_SIZE="$SIZE" GEN_QUALITY="$QUALITY" \
    docker exec -i -e GEN_PROMPT -e GEN_SIZE -e GEN_QUALITY mind_of_god bash -c \
    "source /home/GOD/system_config.sh && python3 /tmp/_gen_runner.py" 2>&1

# Copy output back to host
if docker cp mind_of_god:/tmp/_gen_out.png "$OUTPUT_ABS" 2>/dev/null; then
    docker exec mind_of_god rm -f /tmp/_gen_out.png /tmp/_gen_runner.py 2>/dev/null
    echo "Saved: $OUTPUT_ABS ($(wc -c < "$OUTPUT_ABS" 2>/dev/null || echo 0) bytes)"
else
    echo "ERROR: image not generated"
    docker exec mind_of_god rm -f /tmp/_gen_runner.py 2>/dev/null
    exit 1
fi

rm -f /tmp/_gen_runner.py