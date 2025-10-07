#!/usr/bin/env bash
set -euo pipefail

# Avvia Docker daemon in background
nohup dockerd >/var/log/dockerd.log 2>&1 &

# Attendi che sia pronto
for i in {1..60}; do
  if docker info >/dev/null 2>&1; then
    break
  fi
  sleep 1
  if [ "$i" -eq 60 ]; then
    echo "dockerd non è partito. Log ultimi 200 linee:"
    tail -n 200 /var/log/dockerd.log || true
    exit 1
  fi
done

# --- Git bootstrap su /workspace ---
# Variabili opzionali:
#   GIT_REPO=https://... (obbligatoria per clonare)
#   GIT_REF=main|tag|sha (opzionale)
#   GIT_FORCE=1   -> svuota /workspace e riclona
#   GIT_SYNC=1    -> se /workspace è già un repo, fa fetch/reset

if [ -n "${GIT_REPO:-}" ]; then
  # se /workspace è vuota?
  if [ -z "$(ls -A /workspace 2>/dev/null || true)" ] || [ "${GIT_FORCE:-0}" = "1" ]; then
    # pulizia opzionale se FORCED
    if [ "${GIT_FORCE:-0}" = "1" ]; then
      shopt -s dotglob nullglob
      rm -rf /workspace/* || true
      shopt -u dotglob
    fi
    echo "Clono ${GIT_REPO} in /workspace..."
    git clone --depth 1 "${GIT_REPO}" /workspace
    if [ -n "${GIT_REF:-}" ]; then
      cd /workspace
      git fetch origin "${GIT_REF}" --depth 1 || true
      git checkout -q "${GIT_REF}" || true
    fi
  elif [ "${GIT_SYNC:-0}" = "1" ]; then
    # sincronizza un repo già presente
    echo "Sincronizzo repository in /workspace..."
    git config --global --add safe.directory /workspace || true
    cd /workspace
    if [ -d .git ]; then
      git fetch --all --prune
      if [ -n "${GIT_REF:-}" ]; then
        git checkout -q "${GIT_REF}" || true
        git reset --hard "origin/${GIT_REF}" || true
      else
        git pull --rebase || true
      fi
    else
      echo "/workspace non è un repo git; salta sync."
    fi
  fi
fi

# Esegui il comando richiesto (default: bash)
exec "$@"
