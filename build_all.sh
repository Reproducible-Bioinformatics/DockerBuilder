#!/bin/bash
set -e

echo "🔧 Building stage1 Docker image with CREDO tool..."
docker build -f Dockerfile.stage1 -t credo-stage1 .

echo "📄 Copying credo_install.sh into container and running it..."

docker build -f Dockerfile.final -t credotest .

echo "✅ credo pip phase completed. Check ./credo_env for downloaded packages."
