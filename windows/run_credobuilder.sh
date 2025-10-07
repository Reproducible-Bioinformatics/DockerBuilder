#!/usr/bin/env bash
set -euo pipefail

docker build -t repbioinfo/credobuilder-dind .

# Clona in /workspace/DockerBuilder e resta nella shell
docker run --privileged --rm -it \
  -v "${PWD}:/workspace" -w /workspace \
  repbioinfo/credobuilder-dind \
  bash -lc 'git clone --depth 1 https://github.com/Reproducible-Bioinformatics/DockerBuilder.git DockerBuilder || true; ls -la DockerBuilder; echo ""; echo "[ OK ] Repo pronto in /workspace/DockerBuilder"; exec bash'
