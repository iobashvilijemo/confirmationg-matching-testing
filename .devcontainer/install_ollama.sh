#!/usr/bin/env bash
set -euo pipefail

# Install Ollama if not already installed
if command -v ollama >/dev/null 2>&1; then
  echo "ollama is already installed: $(command -v ollama)"
  exit 0
fi

echo "Installing required packages (curl, ca-certificates) if missing..."
if ! command -v curl >/dev/null 2>&1; then
  sudo apt-get update && sudo apt-get install -y curl ca-certificates
fi

echo "Running Ollama install script..."
# Run the official install script as root
curl -fsSL https://ollama.com/install.sh | sudo sh

if command -v ollama >/dev/null 2>&1; then
  echo "Ollama installed to: $(command -v ollama)"
else
  echo "Ollama installation failed or binary not on PATH. Check the installer output above." >&2
  exit 1
fi
