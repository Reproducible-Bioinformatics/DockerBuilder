#!/bin/bash
set -e

TEMP_TAG="credo-stage1-temp-$(date +%s)"
TMP_CONTAINER="credo-temp-container-$(date +%s)"

# Controlla che sia stato fornito un nome per l'immagine finale
if [ -z "$1" ]; then
  echo "Usage: $0 <final_image_name>"
  exit 1
fi

# Cache cleanup flag
if [ "$2" == "--clean-cache" ]; then
  echo "Cleaning Docker build cache..."
  docker builder prune -af || true
fi

echo "Building stage1 Docker image with CREDO..."
docker build --no-cache --pull -f Dockerfile.stage1 -t $TEMP_TAG .

echo "Extracting /credo_env from stage1 image..."
docker rm -f $TMP_CONTAINER 2>/dev/null || true
docker create --name $TMP_CONTAINER $TEMP_TAG
rm -rf ./credo_env
docker cp $TMP_CONTAINER:/credo_env ./credo_env
sync
docker rm $TMP_CONTAINER

if [ ! -d "./credo_env" ]; then
  echo "Error: Failed to extract /credo_env from the stage1 image."
  exit 1
fi

echo "Building final image using local copy of credo_env..."
docker build --no-cache -f Dockerfile.final -t "$1" .

echo "✅ Final image '$1' built successfully."
