#!/usr/bin/env bash
set -euo pipefail

sudo apt install -y docker.io docker-compose
sudo usermod -aG docker "$USER"

echo
echo "Docker installed. Group membership only takes effect on next login:"
echo "  log out and back in, or run 'newgrp docker' in this shell, then verify with 'docker ps'."
