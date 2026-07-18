#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sudo apt install -y mosquitto mosquitto-clients redis-server redis-tools gpg

sudo mkdir -p /etc/apt/keyrings/
sudo sh -c 'wget -q -O - https://artifacts.chirpstack.io/packages/chirpstack.key | gpg --dearmor > /etc/apt/keyrings/chirpstack.gpg'
echo "deb [signed-by=/etc/apt/keyrings/chirpstack.gpg] https://artifacts.chirpstack.io/packages/4.x/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/chirpstack.list

sudo apt update
sudo apt install -y chirpstack-sqlite

sudo mkdir -p /var/lib/chirpstack
sudo chown chirpstack:chirpstack /var/lib/chirpstack
sudo chmod 0750 /var/lib/chirpstack
sudo install -o chirpstack -g chirpstack -m 0640 /dev/null /var/lib/chirpstack/chirpstack.sqlite

sudo install -o chirpstack -g chirpstack -m 0640 "$REPO_DIR/config-templates/chirpstack.toml" /etc/chirpstack/chirpstack.toml
sudo sed -i "s|secret = \"you-must-replace-this\"|secret = \"$(openssl rand -base64 32)\"|" /etc/chirpstack/chirpstack.toml

sudo systemctl enable --now chirpstack-sqlite

echo
echo "ChirpStack running on :8080 — default login admin/admin, change it before exposing this device."
