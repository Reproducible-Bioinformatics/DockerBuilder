#!/bin/bash
set -e

# svuota cache (opzionale ma utile)
docker builder prune -af || true

echo "Building stage1 Docker image with CREDO..."
docker build --no-cache --pull -f Dockerfile.stage1 -t credo-stage1 .

echo "Extracting /credo_env from stage1 image..."
docker rm -f tmp_container 2>/dev/null || true
docker create --name tmp_container credo-stage1
rm -rf ./credo_env
docker cp tmp_container:/credo_env ./credo_env
docker rm tmp_container

echo "Building final image using local copy of credo_env..."
docker build --no-cache -f Dockerfile.final -t "$1" .

echo "✅ Final image '$1' built successfully."
