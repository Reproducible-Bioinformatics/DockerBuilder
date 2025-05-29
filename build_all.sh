#!/bin/bash
set -e

if [[ "$(docker images -q credo/core:local 2> /dev/null)" == "" ]]; then
  echo "🔧 Building base CREDO image (credo/core:local)..."
  docker build -f Dockerfile.credo -t credo/core:local .
else
  echo "✅ Base image credo/core:local already exists. Skipping build."
fi

echo "🔧 Building stage1 Docker image with CREDO..."
docker build -f Dockerfile.stage1 -t credo-stage1 .

echo "📦 Building final image using packages from stage1..."
docker build -f Dockerfile.final -t credotest .

echo "✅ Final image 'credotest' built successfully."
