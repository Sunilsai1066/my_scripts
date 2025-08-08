#!/bin/bash

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

# Initialize total duration
total=0

# Loop over mp4 files in the given directory
shopt -s nullglob
for f in "$DIR"/*.mp4; do
  dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
  total=$(echo "$total + $dur" | bc)
done

# Convert total seconds to HH:MM:SS
hours=$(echo "$total/3600" | bc)
minutes=$(echo "($total%3600)/60" | bc)
seconds=$(echo "$total%60" | bc)

printf "Total duration: %02d:%02d:%02d\n" "$hours" "$minutes" "$seconds"
