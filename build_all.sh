#!/bin/bash
set -e

echo "🔧 Building stage1 Docker image with CREDO base..."
docker build -f Dockerfile.stage1 -t credo-stage1 .

echo "📦 Building final image from official CREDO base and stage1 packages..."
docker build -f Dockerfile.final -t credotest .

echo "✅ Final image 'credotest' built successfully."
