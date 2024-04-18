#!/bin/zsh

# Check if the directory argument is provided
if [[ -z "$1" ]]
then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Navigate to the directory
cd "$1" || exit

# Process each image file
for img in *.png
do
  if [[ -f "$img" ]]; then
    echo "Resizing $img..."
    # Resize the image to 50% of its original dimensions
    magick convert "$img" -resize 50% "$img"
  fi
done

echo "All images have been resized."

