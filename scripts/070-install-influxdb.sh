#!/usr/bin/env bash
set -euo pipefail

curl --silent --location -O https://repos.influxdata.com/influxdata-archive.key
gpg --show-keys --with-fingerprint --with-colons ./influxdata-archive.key 2>&1 \
  | grep -q '^fpr:\+24C975CBA61A024EE1B631787C3D57159FC2F927:$' \
  && echo "fingerprint OK" || { echo "InfluxData key fingerprint mismatch — aborting."; rm -f influxdata-archive.key; exit 1; }

sudo mkdir -p /etc/apt/keyrings
cat influxdata-archive.key | gpg --dearmor | sudo tee /etc/apt/keyrings/influxdata-archive.gpg > /dev/null
rm influxdata-archive.key
echo 'deb [signed-by=/etc/apt/keyrings/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' \
  | sudo tee /etc/apt/sources.list.d/influxdata.list

sudo apt update
sudo apt install -y influxdb2 influxdb2-cli
sudo systemctl enable --now influxdb

TOKEN="$(openssl rand -hex 32)"
read -rsp "Choose an InfluxDB password: " INFLUX_PASSWORD; echo

influx setup --username fiberlite --password "$INFLUX_PASSWORD" \
  --org fiber-lite --bucket fiber-lite --token "$TOKEN" --force

echo
echo "InfluxDB running on :8086."
echo "Token (save this — needed for the Node-RED flow and the Grafana datasource): $TOKEN"
