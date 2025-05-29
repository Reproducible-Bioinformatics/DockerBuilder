#!/bin/bash
set -e

echo "🔧 Building stage1 Docker image with CREDO..."
docker build -f Dockerfile.stage1 -t credo-stage1 .

echo "📤 Extracting /credo_env from stage1 image..."
docker create --name tmp_container credo-stage1
docker cp tmp_container:/credo_env ./credo_env
docker rm tmp_container

echo "📦 Building final image using local copy of credo_env..."
docker build -f Dockerfile.final -t credotest .

echo "✅ Final image 'credotest' built successfully."
