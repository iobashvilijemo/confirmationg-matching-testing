#!/usr/bin/env bash
set -euo pipefail

if ! command -v ollama >/dev/null 2>&1; then
  echo "ollama not found; run .devcontainer/install_ollama.sh first" >&2
  exit 1
fi

# Start Ollama daemon in background if not already running
if ! pgrep -f "ollama daemon" >/dev/null 2>&1; then
  echo "Starting Ollama daemon..."
  ollama daemon >/tmp/ollama.log 2>&1 &
  sleep 1
  echo "Ollama daemon started (logs: /tmp/ollama.log)"
else
  echo "Ollama daemon already running"
fi

echo "Access the Ollama HTTP API at http://localhost:11434 (default)."