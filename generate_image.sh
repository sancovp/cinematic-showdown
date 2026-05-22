#!/bin/bash
# generate_image.sh — Generate images via OpenAI gpt-image-2 (inside mind_of_god docker)
# Usage: ./generate_image.sh "<prompt>" <output_path> [size] [quality]
# Example: ./generate_image.sh "A cinematic hero shot" ./hero.png "1536x1024" "low"

PROMPT="${1:?Usage: $0 <prompt> <output_path> [size] [quality]}"
OUTPUT="${2:?Usage: $0 <prompt> <output_path> [size] [quality]}"
SIZE="${3:-1024x1024}"
QUALITY="${4:-low}"

# Resolve OUTPUT to absolute path on host
OUTPUT_ABS="$(cd "$(dirname "$OUTPUT")" && pwd)/$(basename "$OUTPUT")"

# Generate in docker
docker exec mind_of_god bash -c "source /home/GOD/system_config.sh && python3 - <<'PYEOF'
from cave_teams import generate_image
r = generate_image(
    prompt='''$PROMPT'''.strip(),
    output_path='/tmp/_gen_out.png',
    size='''$SIZE'''.strip(),
    quality='''$QUALITY'''.strip()
)
if r.success:
    print('GENERATED')
else:
    print('ERROR:' + str(r.error))
PYEOF" 2>&1

# Copy out (on host, not inside container)
if [ -f "/tmp/_gen_out.png" ]; then
    docker cp mind_of_god:/tmp/_gen_out.png "$OUTPUT_ABS" && docker exec mind_of_god rm -f /tmp/_gen_out.png
fi

ls -la "$OUTPUT_ABS" 2>/dev/null