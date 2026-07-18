#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$HOME/fiber-lite-dashboard"
cp "$REPO_DIR/dashboard/index.html" "$REPO_DIR/dashboard/serve.py" "$HOME/fiber-lite-dashboard/"
chmod +x "$HOME/fiber-lite-dashboard/serve.py"

sed "s|__HOME__|$HOME|g" "$REPO_DIR/dashboard/fiber-lite-dashboard.service" \
  | sudo tee /etc/systemd/system/fiber-lite-dashboard.service > /dev/null

sudo systemctl daemon-reload
sudo systemctl enable --now fiber-lite-dashboard.service

echo
echo "Dashboard running on :80."
