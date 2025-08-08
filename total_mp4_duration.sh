#!/bin/bash

# Usage
#$ ./total_mp4_duration.sh ~/Downloads/MyVideos
#Total duration: 01:25:42
# Check if a path was provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/directory"
  exit 1
fi

DIR="$1"

# Check if ffprobe is installed
if ! command -v ffprobe >/dev/null 2>&1; then
  echo "Error: ffprobe (from ffmpeg) is not installed."
  exit 1
fi

# Check if bc is installed
if ! command -v bc >/dev/null 2>&1; then
  echo "Error: bc (calculator) is not installed."
  exit 1
fi

# Initialize total duration
total=0

shopt -s nullglob
for f in "$DIR"/*.mp4; do
  dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
  total=$(echo "$total + $dur" | bc)
done

# Round total to nearest integer second
total_seconds=$(printf "%.0f" "$total")

# Convert to HH:MM:SS
hours=$(( total_seconds / 3600 ))
minutes=$(( (total_seconds % 3600) / 60 ))
seconds=$(( total_seconds % 60 ))

printf "Total duration: %02d:%02d:%02d\n" "$hours" "$minutes" "$seconds"
