#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt upgrade -y

echo
echo "System updated. Reboot before continuing: sudo reboot"
