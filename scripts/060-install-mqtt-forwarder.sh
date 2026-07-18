#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sudo apt install -y chirpstack-mqtt-forwarder
sudo install -m 0644 "$REPO_DIR/config-templates/chirpstack-mqtt-forwarder.toml" \
  /etc/chirpstack-mqtt-forwarder/chirpstack-mqtt-forwarder.toml
sudo systemctl enable --now chirpstack-mqtt-forwarder

echo
echo "MQTT Forwarder running. Check logs: sudo journalctl -fu chirpstack-mqtt-forwarder"
echo "Depends on the concentrator already running (see 050-check-concentratord-prereqs.sh)."
