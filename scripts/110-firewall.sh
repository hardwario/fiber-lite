#!/usr/bin/env bash
set -euo pipefail

read -rp "LAN subnet to allow for the web UIs (CIDR, e.g. 10.0.0.0/24): " SUBNET

sudo apt install -y ufw
sudo ufw allow 22/tcp
for port in 80 1880 8080 8086 3000; do
  sudo ufw allow from "$SUBNET" to any port "$port"
done
sudo ufw enable

echo
echo "Firewall enabled. Verify SSH and all web UIs are still reachable from another machine"
echo "on the LAN before disconnecting."
